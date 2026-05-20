package com.snippetmanager.service;

import com.snippetmanager.dao.SnippetDAO;
import com.snippetmanager.entity.Snippet;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;

/**
 * SERVICE IMPLEMENTATION — SnippetServiceImpl.java
 *
 * This class implements SnippetService and contains:
 *   1. @Transactional management  — most important responsibility
 *   2. Business logic / validation
 *   3. Delegation to the DAO layer
 *
 * ─────────────────────────────────────────────────────────────
 *  UNDERSTANDING @Transactional  ← VERY IMPORTANT FOR INTERVIEW
 * ─────────────────────────────────────────────────────────────
 * A DATABASE TRANSACTION is a unit of work that either:
 *   - Completes FULLY (COMMIT)   → all changes saved
 *   - Fails ENTIRELY (ROLLBACK)  → all changes undone
 *
 * @Transactional tells Spring:
 *   "Before this method runs → open a transaction (BEGIN)"
 *   "If method succeeds      → commit the transaction (COMMIT)"
 *   "If exception is thrown  → roll back everything (ROLLBACK)"
 *
 * We put @Transactional on the SERVICE (not DAO) because:
 *   - A single service operation might call MULTIPLE DAOs
 *   - All those DAO calls must succeed or fail TOGETHER
 *   - The transaction should span the entire business operation
 *
 * Example: If "save snippet + update tag count" both need to
 * happen together, wrapping the service method in @Transactional
 * ensures both succeed or both roll back atomically.
 *
 * ─────────────────────────────────────────────────────────────
 *  KEY ANNOTATIONS
 * ─────────────────────────────────────────────────────────────
 * @Service     → Tells Spring this is a Service bean.
 *                Spring creates one instance and manages it.
 *                Semantically identical to @Component but
 *                communicates intent: "this is a service class".
 *
 * @Autowired   → Spring injects the SnippetDAO implementation
 *                (SnippetDAOImpl) automatically. We depend on the
 *                INTERFACE (SnippetDAO), not the concrete class —
 *                this is Dependency Injection in action.
 */
@Service
public class SnippetServiceImpl implements SnippetService {

    // ----------------------------------------------------------
    //  Inject the DAO interface — Spring will provide the
    //  SnippetDAOImpl instance at runtime automatically.
    //  We code to the interface, not the implementation.
    // ----------------------------------------------------------
    private final SnippetDAO snippetDAO;

    @Autowired
    public SnippetServiceImpl(SnippetDAO snippetDAO) {
        this.snippetDAO = snippetDAO;
    }

    // ==========================================================
    //  1. SAVE NEW SNIPPET
    //
    //  @Transactional → Spring opens a DB transaction before
    //  this method, commits after, rolls back on exception.
    // ==========================================================
    @Override
    @Transactional
    public void saveSnippet(Snippet snippet) {
        // ── Business Rule: trim whitespace from text fields ──
        // Prevents saving "  Java  " instead of "Java"
        if (snippet.getTitle() != null) {
            snippet.setTitle(snippet.getTitle().trim());
        }
        if (snippet.getLanguage() != null) {
            snippet.setLanguage(snippet.getLanguage().trim());
        }
        if (snippet.getTags() != null) {
            snippet.setTags(snippet.getTags().trim());
        }

        // ── Business Rule: basic validation ──
        // In a larger project this would throw a custom exception
        // caught by a @ControllerAdvice global exception handler.
        if (snippet.getTitle() == null || snippet.getTitle().isEmpty()) {
            throw new IllegalArgumentException("Snippet title cannot be empty.");
        }
        if (snippet.getCode() == null || snippet.getCode().isEmpty()) {
            throw new IllegalArgumentException("Snippet code cannot be empty.");
        }

        // All good — delegate to DAO to persist to DB
        snippetDAO.saveSnippet(snippet);
    }

    // ==========================================================
    //  2. GET ALL SNIPPETS
    //
    //  readOnly = true → tells Spring/Hibernate this transaction
    //  won't modify data. Hibernate skips dirty-checking
    //  (comparing entity state to detect changes), which is
    //  a performance optimisation for read-only operations.
    // ==========================================================
    @Override
    @Transactional(readOnly = true)
    public List<Snippet> getAllSnippets() {
        return snippetDAO.getAllSnippets();
    }

    // ==========================================================
    //  3. GET SNIPPET BY ID
    //
    //  Also read-only — we're just fetching, not modifying.
    // ==========================================================
    @Override
    @Transactional(readOnly = true)
    public Snippet getSnippetById(int id) {
        return snippetDAO.getSnippetById(id);
    }

    // ==========================================================
    //  4. UPDATE EXISTING SNIPPET
    // ==========================================================
    @Override
    @Transactional
    public void updateSnippet(Snippet snippet) {
        // ── Business Rule: trim whitespace on update too ──
        if (snippet.getTitle() != null) {
            snippet.setTitle(snippet.getTitle().trim());
        }
        if (snippet.getLanguage() != null) {
            snippet.setLanguage(snippet.getLanguage().trim());
        }
        if (snippet.getTags() != null) {
            snippet.setTags(snippet.getTags().trim());
        }

        // ── Business Rule: validate before updating ──
        if (snippet.getTitle() == null || snippet.getTitle().isEmpty()) {
            throw new IllegalArgumentException("Snippet title cannot be empty.");
        }
        if (snippet.getCode() == null || snippet.getCode().isEmpty()) {
            throw new IllegalArgumentException("Snippet code cannot be empty.");
        }

        snippetDAO.updateSnippet(snippet);
    }

    // ==========================================================
    //  5. DELETE SNIPPET
    // ==========================================================
    @Override
    @Transactional
    public void deleteSnippet(int id) {
        // ── Business Rule: validate id is positive ──
        if (id <= 0) {
            throw new IllegalArgumentException("Invalid snippet ID: " + id);
        }
        snippetDAO.deleteSnippet(id);
    }

    // ==========================================================
    //  6. SEARCH SNIPPETS
    // ==========================================================
    @Override
    @Transactional(readOnly = true)
    public List<Snippet> searchSnippets(String keyword) {
        // ── Business Rule: handle null/blank keyword ──
        // If user submits an empty search, return all snippets
        // rather than running a meaningless LIKE '%%' query.
        if (keyword == null || keyword.trim().isEmpty()) {
            return snippetDAO.getAllSnippets();
        }
        return snippetDAO.searchSnippets(keyword.trim());
    }
}
