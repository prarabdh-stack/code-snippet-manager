package com.snippetmanager.controller;

import com.snippetmanager.entity.Snippet;
import com.snippetmanager.service.SnippetService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import java.util.List;

/**
 * CONTROLLER — SnippetController.java
 *
 * This is the FRONT DOOR of the application for every HTTP request.
 * Spring's DispatcherServlet receives all incoming requests and
 * routes them to the correct method in this controller based on
 * the URL and HTTP method (GET / POST).
 *
 * ─────────────────────────────────────────────────────────────
 *  HOW SPRING MVC REQUEST FLOW WORKS
 * ─────────────────────────────────────────────────────────────
 *
 *  Browser                DispatcherServlet         Controller
 *    │                          │                       │
 *    │── GET /snippets ────────>│                       │
 *    │                          │── routes to ─────────>│
 *    │                          │                       │── calls Service
 *    │                          │                       │── gets data
 *    │                          │                       │── adds to Model
 *    │                          │<── "list-snippets" ───│
 *    │                          │── ViewResolver ──> list-snippets.jsp
 *    │<─── HTML response ───────│
 *
 * ─────────────────────────────────────────────────────────────
 *  KEY ANNOTATIONS
 * ─────────────────────────────────────────────────────────────
 * @Controller       → Marks this as a Spring MVC controller bean.
 *                     Unlike @RestController (used in REST APIs),
 *                     @Controller returns VIEW NAMES (JSP pages),
 *                     not raw JSON/XML data.
 *
 * @RequestMapping   → Sets the BASE URL for all methods in this class.
 *                     Every URL here starts with /snippets.
 *
 * @Autowired        → Spring injects SnippetServiceImpl automatically.
 *                     We depend on the interface, not the concrete class.
 */
@Controller
@RequestMapping("/snippets")
public class SnippetController {

    // ----------------------------------------------------------
    //  Inject the Service layer — Controller never touches DAO
    // ----------------------------------------------------------
    private final SnippetService snippetService;

    @Autowired
    public SnippetController(SnippetService snippetService) {
        this.snippetService = snippetService;
    }

    // ==========================================================
    //  1. LIST ALL SNIPPETS
    //  URL:    GET /snippets
    //  Shows:  list-snippets.jsp with all snippets
    // ==========================================================

    /**
     * Model → a Map-like object Spring provides.
     * We add data to it with model.addAttribute("key", value).
     * The JSP then accesses it with ${key}.
     */
    @GetMapping
    public String listSnippets(Model model) {
        // Fetch all snippets from DB via Service
        List<Snippet> snippets = snippetService.getAllSnippets();

        // Add to model so JSP can display them
        model.addAttribute("snippets", snippets);

        // Return the VIEW NAME — Spring's ViewResolver will look for:
        // /WEB-INF/views/list-snippets.jsp
        return "list-snippets";
    }

    // ==========================================================
    //  2. SHOW "ADD NEW SNIPPET" FORM
    //  URL:    GET /snippets/new
    //  Shows:  add-snippet.jsp with an empty form
    // ==========================================================
    @GetMapping("/new")
    public String showAddForm(Model model) {
        // Pass a blank Snippet object to the form.
        // Spring MVC's form binding (<form:form modelAttribute="snippet">)
        // uses this object to pre-populate fields (all empty here).
        model.addAttribute("snippet", new Snippet());

        return "add-snippet";
    }

    // ==========================================================
    //  3. HANDLE "ADD NEW SNIPPET" FORM SUBMISSION
    //  URL:    POST /snippets/save
    //  Action: Save snippet → redirect to list
    // ==========================================================

    /**
     * @ModelAttribute → Spring automatically maps the HTML form fields
     * to the Snippet object's fields using the setter methods.
     *
     * For example, the HTML input with name="title" maps to
     * snippet.setTitle(...) automatically. No manual parsing needed!
     *
     * RedirectAttributes → used to pass a one-time "flash" message
     * to the next page after a redirect. The message is stored
     * temporarily and automatically removed after one display.
     */
    @PostMapping("/save")
    public String saveSnippet(@ModelAttribute("snippet") Snippet snippet,
                              RedirectAttributes redirectAttributes) {
        try {
            snippetService.saveSnippet(snippet);

            // Flash message → survives the redirect and shows once
            redirectAttributes.addFlashAttribute("successMessage",
                    "Snippet '" + snippet.getTitle() + "' saved successfully!");

        } catch (IllegalArgumentException e) {
            // Validation failed — send error message back to the form
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
            return "redirect:/snippets/new";
        }

        // POST → REDIRECT → GET pattern (PRG):
        // After a successful POST, we REDIRECT to the list page.
        // This prevents duplicate form submissions if user hits F5.
        return "redirect:/snippets";
    }

    // ==========================================================
    //  4. VIEW SINGLE SNIPPET DETAILS
    //  URL:    GET /snippets/{id}
    //  Shows:  view-snippet.jsp with one snippet's full details
    // ==========================================================

    /**
     * @PathVariable → extracts {id} from the URL.
     * e.g. GET /snippets/3 → id = 3
     */
    @GetMapping("/{id}")
    public String viewSnippet(@PathVariable("id") int id, Model model) {
        Snippet snippet = snippetService.getSnippetById(id);

        // Guard: if snippet doesn't exist, redirect to list
        if (snippet == null) {
            return "redirect:/snippets";
        }

        model.addAttribute("snippet", snippet);
        return "view-snippet";
    }

    // ==========================================================
    //  5. SHOW "EDIT SNIPPET" FORM
    //  URL:    GET /snippets/{id}/edit
    //  Shows:  edit-snippet.jsp pre-filled with existing data
    // ==========================================================
    @GetMapping("/{id}/edit")
    public String showEditForm(@PathVariable("id") int id, Model model) {
        Snippet snippet = snippetService.getSnippetById(id);

        // Guard: if snippet doesn't exist, redirect to list
        if (snippet == null) {
            return "redirect:/snippets";
        }

        // Pass the existing snippet — the form will be PRE-FILLED
        // with its current values (title, language, code, tags)
        model.addAttribute("snippet", snippet);
        return "edit-snippet";
    }

    // ==========================================================
    //  6. HANDLE "EDIT SNIPPET" FORM SUBMISSION
    //  URL:    POST /snippets/update
    //  Action: Update snippet → redirect to its detail page
    // ==========================================================
    @PostMapping("/update")
    public String updateSnippet(@ModelAttribute("snippet") Snippet snippet,
                                RedirectAttributes redirectAttributes) {
        try {
            snippetService.updateSnippet(snippet);

            redirectAttributes.addFlashAttribute("successMessage",
                    "Snippet updated successfully!");

        } catch (IllegalArgumentException e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
            // Return to the edit form on validation error
            return "redirect:/snippets/" + snippet.getId() + "/edit";
        }

        // Redirect to the detail page of the updated snippet
        return "redirect:/snippets/" + snippet.getId();
    }

    // ==========================================================
    //  7. DELETE A SNIPPET
    //  URL:    GET /snippets/{id}/delete
    //  Action: Delete → redirect to list with confirmation message
    //
    //  NOTE: Ideally this would be HTTP DELETE method, but HTML
    //  forms only support GET and POST. Using GET /delete/{id}
    //  is a common, acceptable pattern in JSP-based MVC apps.
    // ==========================================================
    @GetMapping("/{id}/delete")
    public String deleteSnippet(@PathVariable("id") int id,
                                RedirectAttributes redirectAttributes) {
        try {
            snippetService.deleteSnippet(id);
            redirectAttributes.addFlashAttribute("successMessage",
                    "Snippet deleted successfully.");

        } catch (IllegalArgumentException e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
        }

        return "redirect:/snippets";
    }

    // ==========================================================
    //  8. SEARCH SNIPPETS
    //  URL:    GET /snippets/search?keyword=java
    //  Shows:  list-snippets.jsp with filtered results
    // ==========================================================

    /**
     * @RequestParam → extracts a query parameter from the URL.
     * e.g. GET /snippets/search?keyword=java → keyword = "java"
     *
     * required = false    → keyword is optional (won't 400 if missing)
     * defaultValue = ""   → if missing, defaults to empty string
     *                       (Service will then return all snippets)
     */
    @GetMapping("/search")
    public String searchSnippets(
            @RequestParam(value = "keyword", required = false, defaultValue = "") String keyword,
            Model model) {

        List<Snippet> results = snippetService.searchSnippets(keyword);

        // Pass results AND the keyword back to JSP
        // so we can display "3 results for 'java'" in the view
        model.addAttribute("snippets", results);
        model.addAttribute("keyword", keyword);
        model.addAttribute("resultCount", results.size());

        return "list-snippets";
    }
}
