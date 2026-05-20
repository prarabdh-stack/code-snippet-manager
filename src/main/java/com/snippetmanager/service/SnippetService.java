package com.snippetmanager.service;

import com.snippetmanager.entity.Snippet;
import java.util.List;

/**
 * SERVICE INTERFACE — SnippetService.java
 *
 * This interface defines the BUSINESS OPERATIONS available
 * for the Snippet feature.
 *
 * WHY A SEPARATE SERVICE LAYER?
 * ------------------------------
 * The Controller should only handle HTTP (request/response).
 * The DAO should only handle database operations.
 * The SERVICE handles everything in between:
 *
 *   - Business rules (e.g. "title must not be blank")
 *   - Transaction management (@Transactional lives here)
 *   - Coordinating multiple DAO calls if needed
 *   - Data transformation before saving / after fetching
 *
 * ANALOGY:
 *   Controller = Waiter      (takes the order)
 *   Service    = Chef        (prepares/validates the order)
 *   DAO        = Ingredients (raw data access)
 *   DB         = Pantry      (storage)
 *
 * The Controller calls Service methods — it never calls DAO directly.
 * This keeps each layer focused on ONE responsibility (Single
 * Responsibility Principle — one of the SOLID principles).
 */
public interface SnippetService {

    /**
     * Business operation: save a new snippet.
     * The service may validate or transform the snippet
     * before delegating to the DAO.
     *
     * @param snippet the snippet to save
     */
    void saveSnippet(Snippet snippet);

    /**
     * Business operation: retrieve all snippets for the list view.
     *
     * @return all snippets, newest first
     */
    List<Snippet> getAllSnippets();

    /**
     * Business operation: get one snippet for the detail/edit view.
     *
     * @param id primary key of the snippet
     * @return the Snippet, or null if not found
     */
    Snippet getSnippetById(int id);

    /**
     * Business operation: update an existing snippet.
     *
     * @param snippet the snippet with updated values
     */
    void updateSnippet(Snippet snippet);

    /**
     * Business operation: delete a snippet permanently.
     *
     * @param id primary key of the snippet to delete
     */
    void deleteSnippet(int id);

    /**
     * Business operation: search snippets by keyword.
     * Searches across title and language fields.
     *
     * @param keyword the search term
     * @return matching snippets, newest first
     */
    List<Snippet> searchSnippets(String keyword);
}
