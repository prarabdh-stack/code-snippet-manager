package com.snippetmanager.dao;

import com.snippetmanager.entity.Snippet;
import java.util.List;

/**
 * DAO INTERFACE — SnippetDAO.java
 *
 * This interface defines the CONTRACT for all database operations.
 * It answers the question: "What can we DO with Snippets in the DB?"
 *
 * WHY AN INTERFACE?
 * -----------------
 * 1. LOOSE COUPLING — The Service layer depends on this interface,
 *    NOT on the implementation. If we ever swap Hibernate for JDBC
 *    or JPA, we only change the Impl class. The Service stays untouched.
 *
 * 2. TESTABILITY — In unit tests, we can create a mock/fake
 *    implementation of this interface without touching the real DB.
 *
 * 3. CLEAN DESIGN — Anyone reading this interface immediately knows
 *    every DB operation available, without reading implementation details.
 *
 * PATTERN: This follows the classic DAO (Data Access Object) pattern —
 * a standard in enterprise Java development.
 */
public interface SnippetDAO {

    /**
     * Save a brand-new snippet to the database.
     * Hibernate will execute: INSERT INTO snippets (...)
     *
     * @param snippet the Snippet object to persist
     */
    void saveSnippet(Snippet snippet);

    /**
     * Retrieve all snippets from the database.
     * Hibernate will execute: SELECT * FROM snippets
     *
     * @return List of all Snippet objects (empty list if none exist)
     */
    List<Snippet> getAllSnippets();

    /**
     * Retrieve one specific snippet by its primary key (id).
     * Hibernate will execute: SELECT * FROM snippets WHERE id = ?
     *
     * @param id the primary key of the snippet
     * @return the Snippet object, or null if not found
     */
    Snippet getSnippetById(int id);

    /**
     * Update an existing snippet in the database.
     * Hibernate will execute: UPDATE snippets SET ... WHERE id = ?
     *
     * @param snippet the Snippet object with updated values
     */
    void updateSnippet(Snippet snippet);

    /**
     * Delete a snippet from the database by its id.
     * Hibernate will execute: DELETE FROM snippets WHERE id = ?
     *
     * @param id the primary key of the snippet to delete
     */
    void deleteSnippet(int id);

    /**
     * Search snippets by title OR language (case-insensitive).
     * Hibernate will execute a HQL query with LIKE conditions.
     *
     * @param keyword the search term entered by the user
     * @return List of matching Snippet objects
     */
    List<Snippet> searchSnippets(String keyword);
}
