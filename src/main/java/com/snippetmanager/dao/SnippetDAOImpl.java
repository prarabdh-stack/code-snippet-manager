package com.snippetmanager.dao;

import com.snippetmanager.entity.Snippet;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.query.Query;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import java.util.List;

/**
 * DAO IMPLEMENTATION — SnippetDAOImpl.java
 *
 * This class IMPLEMENTS the SnippetDAO interface.
 * It contains the actual Hibernate code that talks to MySQL.
 *
 * KEY ANNOTATIONS:
 * ----------------
 * @Repository → Tells Spring this is a DAO bean.
 *               Spring will:
 *                 1. Create one instance of this class (singleton)
 *                 2. Register it in the Spring container
 *                 3. Translate Hibernate exceptions into Spring's
 *                    DataAccessException hierarchy (cleaner error handling)
 *
 * @Autowired  → Spring automatically injects the SessionFactory
 *               bean that we configure in spring-mvc-config.xml
 *
 * HOW HIBERNATE SESSION WORKS:
 * -----------------------------
 * SessionFactory → Created ONCE at app startup (expensive, heavy object)
 * Session        → Created PER REQUEST (lightweight, short-lived)
 *
 * We call sessionFactory.getCurrentSession() which Spring's transaction
 * management ties to the current thread/request automatically.
 * We NEVER call session.close() manually — Spring handles that.
 */
@Repository
public class SnippetDAOImpl implements SnippetDAO {

    // ----------------------------------------------------------
    //  SessionFactory — injected by Spring
    //  This is the Hibernate "connection factory" — configured
    //  in spring-mvc-config.xml using our hibernate.cfg.xml
    // ----------------------------------------------------------
    private final SessionFactory sessionFactory;

    @Autowired
    public SnippetDAOImpl(SessionFactory sessionFactory) {
        this.sessionFactory = sessionFactory;
    }

    // ----------------------------------------------------------
    //  Helper method — gets the current Hibernate Session.
    //  The Session is bound to the current transaction/thread
    //  by Spring's @Transactional (declared in the Service layer).
    // ----------------------------------------------------------
    private Session getCurrentSession() {
        return sessionFactory.getCurrentSession();
    }

    // ==========================================================
    //  1. SAVE — Insert a new snippet row
    // ==========================================================
    @Override
    public void saveSnippet(Snippet snippet) {
        // session.save() → generates and runs:
        // INSERT INTO snippets (title, language, code, tags, created_at)
        // VALUES (?, ?, ?, ?, ?)
        getCurrentSession().save(snippet);
    }

    // ==========================================================
    //  2. GET ALL — Fetch every row from the snippets table
    // ==========================================================
    @Override
    public List<Snippet> getAllSnippets() {
        // HQL (Hibernate Query Language) — like SQL but uses
        // CLASS names and FIELD names, not table/column names.
        //
        // "FROM Snippet" is HQL equivalent of "SELECT * FROM snippets"
        // Hibernate translates this to SQL automatically.
        //
        // ORDER BY createdAt DESC → newest snippets appear first
        Query<Snippet> query = getCurrentSession()
                .createQuery("FROM Snippet ORDER BY createdAt DESC", Snippet.class);

        return query.getResultList();
    }

    // ==========================================================
    //  3. GET BY ID — Fetch one specific snippet
    // ==========================================================
    @Override
    public Snippet getSnippetById(int id) {
        // session.get() → generates:
        // SELECT * FROM snippets WHERE id = ?
        //
        // Returns null if no row found (unlike session.load()
        // which throws an exception for missing rows)
        return getCurrentSession().get(Snippet.class, id);
    }

    // ==========================================================
    //  4. UPDATE — Modify an existing snippet row
    // ==========================================================
    @Override
    public void updateSnippet(Snippet snippet) {
        // session.merge() → checks if a snippet with this id already
        // exists in the session:
        //   - If YES → updates the existing managed instance
        //   - If NO  → generates: UPDATE snippets SET ... WHERE id = ?
        //
        // We use merge() instead of update() because merge() is safer
        // when the object might be in a detached state (common in
        // web apps where objects are passed across requests).
        getCurrentSession().merge(snippet);
    }

    // ==========================================================
    //  5. DELETE — Remove a snippet row by id
    // ==========================================================
    @Override
    public void deleteSnippet(int id) {
        // Step 1: Fetch the snippet object by id
        // (Hibernate needs a managed entity object to delete it)
        Snippet snippet = getCurrentSession().get(Snippet.class, id);

        // Step 2: Only delete if it actually exists
        if (snippet != null) {
            // session.delete() → generates:
            // DELETE FROM snippets WHERE id = ?
            getCurrentSession().delete(snippet);
        }
    }

    // ==========================================================
    //  6. SEARCH — Find snippets by title OR language keyword
    // ==========================================================
    @Override
    public List<Snippet> searchSnippets(String keyword) {
        // Build a HQL query with LIKE for partial matching.
        //
        // :keyword → named parameter (safe from SQL injection!)
        // LOWER()  → makes the search case-insensitive
        //            e.g. searching "java" also finds "Java", "JAVA"
        //
        // This HQL translates roughly to:
        // SELECT * FROM snippets
        // WHERE LOWER(title) LIKE '%keyword%'
        //    OR LOWER(language) LIKE '%keyword%'
        // ORDER BY created_at DESC

        String hql = "FROM Snippet s WHERE " +
                "LOWER(s.title) LIKE :keyword OR " +
                "LOWER(s.language) LIKE :keyword " +
                "ORDER BY s.createdAt DESC";

        Query<Snippet> query = getCurrentSession()
                .createQuery(hql, Snippet.class);

        // Wrap keyword with % wildcards for LIKE matching
        // e.g. user types "java" → we search for "%java%"
        query.setParameter("keyword", "%" + keyword.toLowerCase() + "%");

        return query.getResultList();
    }
}