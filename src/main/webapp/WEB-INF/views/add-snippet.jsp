<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--
  add-snippet.jsp
  ---------------
  Form to create a brand-new snippet.
  On submit → POST /snippets/save → SnippetController.saveSnippet()

  Model attributes from Controller:
    ${snippet}        → empty Snippet object (for form binding)
    ${errorMessage}   → validation error flash (if redirected back)
--%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Add Snippet — Snippet Manager</title>
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: 'Segoe UI', Tahoma, sans-serif; background: #f0f2f5; color: #333; }

        /* Navbar */
        .navbar {
            background: #1e293b; padding: 0 2rem;
            display: flex; align-items: center; justify-content: space-between;
            height: 60px; box-shadow: 0 2px 8px rgba(0,0,0,0.3);
        }
        .navbar-brand { color: #38bdf8; font-size: 1.3rem; font-weight: 700; text-decoration: none; }
        .navbar-brand span { color: #fff; }
        .nav-link {
            color: #cbd5e1; text-decoration: none; padding: 0.4rem 0.9rem;
            border-radius: 6px; font-size: 0.9rem;
        }
        .nav-link:hover { background: #334155; color: #fff; }

        .container { max-width: 780px; margin: 2.5rem auto; padding: 0 1.5rem; }

        /* Breadcrumb */
        .breadcrumb { font-size: 0.88rem; color: #64748b; margin-bottom: 1.5rem; }
        .breadcrumb a { color: #2563eb; text-decoration: none; }
        .breadcrumb a:hover { text-decoration: underline; }
        .breadcrumb span { margin: 0 0.4rem; }

        /* Card */
        .card {
            background: #fff; border-radius: 12px;
            box-shadow: 0 1px 8px rgba(0,0,0,0.09); padding: 2rem;
        }
        .card-title {
            font-size: 1.4rem; font-weight: 700; color: #1e293b;
            margin-bottom: 0.4rem;
        }
        .card-subtitle { color: #64748b; font-size: 0.9rem; margin-bottom: 1.8rem; }

        /* Alerts */
        .alert { padding: 0.85rem 1.2rem; border-radius: 8px; margin-bottom: 1.5rem; font-size: 0.95rem; }
        .alert-error { background: #fee2e2; color: #991b1b; border-left: 4px solid #dc2626; }

        /* Form */
        .form-group { margin-bottom: 1.4rem; }
        .form-row { display: grid; grid-template-columns: 1fr 1fr; gap: 1rem; }

        label {
            display: block; font-size: 0.88rem; font-weight: 600;
            color: #374151; margin-bottom: 0.4rem;
        }
        label .required { color: #dc2626; margin-left: 2px; }
        label .hint { font-weight: 400; color: #94a3b8; font-size: 0.82rem; }

        input[type="text"],
        select,
        textarea {
            width: 100%; padding: 0.6rem 0.9rem;
            border: 1.5px solid #cbd5e1; border-radius: 7px;
            font-size: 0.95rem; font-family: inherit;
            outline: none; transition: border-color 0.2s;
            color: #1e293b; background: #fff;
        }
        input[type="text"]:focus,
        select:focus,
        textarea:focus { border-color: #2563eb; box-shadow: 0 0 0 3px rgba(37,99,235,0.1); }

        /* Code textarea uses monospace font */
        .code-area {
            font-family: 'Courier New', Courier, monospace;
            font-size: 0.9rem; line-height: 1.6;
            min-height: 260px; resize: vertical;
            background: #0f172a; color: #e2e8f0;
            border-color: #334155;
        }
        .code-area:focus { border-color: #38bdf8; box-shadow: 0 0 0 3px rgba(56,189,248,0.15); }

        /* Char count hint */
        .field-hint { font-size: 0.8rem; color: #94a3b8; margin-top: 0.3rem; }

        /* Buttons */
        .form-actions { display: flex; gap: 0.8rem; margin-top: 1.8rem; }
        .btn {
            display: inline-block; padding: 0.6rem 1.4rem; border-radius: 7px;
            font-size: 0.95rem; font-weight: 600; text-decoration: none;
            cursor: pointer; border: none; transition: opacity 0.2s;
        }
        .btn:hover { opacity: 0.87; }
        .btn-primary { background: #2563eb; color: #fff; }
        .btn-secondary { background: #e2e8f0; color: #475569; }
    </style>
</head>
<body>

<%-- NAVBAR --%>
<nav class="navbar">
    <a href="<c:url value='/snippets'/>" class="navbar-brand">&lt;/&gt; <span>Snippet Manager</span></a>
    <a href="<c:url value='/snippets'/>" class="nav-link">&#8592; Back to List</a>
</nav>

<div class="container">

    <%-- Breadcrumb --%>
    <div class="breadcrumb">
        <a href="<c:url value='/snippets'/>">Snippets</a>
        <span>&#8250;</span>
        Add New Snippet
    </div>

    <%-- Error Flash Message --%>
    <c:if test="${not empty errorMessage}">
        <div class="alert alert-error">&#9888; ${errorMessage}</div>
    </c:if>

    <div class="card">
        <h1 class="card-title">&#128196; Add New Snippet</h1>
        <p class="card-subtitle">Save a reusable piece of code to your personal library.</p>

        <%--
          FORM EXPLANATION:
            action="/snippets/save" → maps to @PostMapping("/save") in Controller
            method="post"           → HTTP POST (sends data in request body, not URL)

          Spring MVC reads form fields by matching the 'name' attribute
          of each input to the setter methods of the Snippet class:
            name="title"    → snippet.setTitle(...)
            name="language" → snippet.setLanguage(...)
            name="code"     → snippet.setCode(...)
            name="tags"     → snippet.setTags(...)
        --%>
        <form action="<c:url value='/snippets/save'/>" method="post">

            <%-- Row 1: Title + Language side by side --%>
            <div class="form-row">

                <div class="form-group">
                    <label for="title">
                        Title <span class="required">*</span>
                        <span class="hint">(short descriptive name)</span>
                    </label>
                    <input type="text"
                           id="title"
                           name="title"
                           placeholder="e.g. Binary Search, Merge Sort"
                           value="${snippet.title}"
                           maxlength="255"
                           required/>
                    <div class="field-hint">Max 255 characters</div>
                </div>

                <div class="form-group">
                    <label for="language">
                        Language <span class="required">*</span>
                    </label>
                    <%--
                      Using a <select> keeps language values consistent
                      (avoids "java", "Java", "JAVA" being treated differently).
                      The Controller reads this as snippet.setLanguage(...)
                    --%>
                    <select id="language" name="language" required>
                        <option value="" disabled selected>-- Select Language --</option>
                        <option value="Java"       ${snippet.language eq 'Java'       ? 'selected' : ''}>Java</option>
                        <option value="Python"     ${snippet.language eq 'Python'     ? 'selected' : ''}>Python</option>
                        <option value="JavaScript" ${snippet.language eq 'JavaScript' ? 'selected' : ''}>JavaScript</option>
                        <option value="C++"        ${snippet.language eq 'C++'        ? 'selected' : ''}>C++</option>
                        <option value="C"          ${snippet.language eq 'C'          ? 'selected' : ''}>C</option>
                        <option value="SQL"        ${snippet.language eq 'SQL'        ? 'selected' : ''}>SQL</option>
                        <option value="Bash"       ${snippet.language eq 'Bash'       ? 'selected' : ''}>Bash</option>
                        <option value="Other"      ${snippet.language eq 'Other'      ? 'selected' : ''}>Other</option>
                    </select>
                </div>

            </div><%-- end .form-row --%>

            <%-- Row 2: Code textarea --%>
            <div class="form-group">
                <label for="code">
                    Code <span class="required">*</span>
                    <span class="hint">(paste your code here)</span>
                </label>
                <%--
                  textarea for code — uses monospace font (class="code-area").
                  name="code" maps to snippet.setCode(...)
                  We do NOT use value="" for textarea; content goes between tags.
                  ${snippet.code} pre-fills if we redirect back after an error.
                --%>
                <textarea id="code"
                          name="code"
                          class="code-area"
                          placeholder="// Paste or type your code here..."
                          required><c:out value="${snippet.code}"/></textarea>
                <div class="field-hint">Supports any language. Preserves indentation.</div>
            </div>

            <%-- Row 3: Tags --%>
            <div class="form-group">
                <label for="tags">
                    Tags
                    <span class="hint">(optional — comma separated)</span>
                </label>
                <input type="text"
                       id="tags"
                       name="tags"
                       placeholder="e.g. array, sorting, DSA, interview"
                       value="${snippet.tags}"
                       maxlength="255"/>
                <div class="field-hint">Separate multiple tags with commas.</div>
            </div>

            <%-- Form Action Buttons --%>
            <div class="form-actions">
                <%-- Submit button — triggers POST /snippets/save --%>
                <button type="submit" class="btn btn-primary">&#10003; Save Snippet</button>

                <%-- Cancel — just goes back to the list (no data sent) --%>
                <a href="<c:url value='/snippets'/>" class="btn btn-secondary">Cancel</a>
            </div>

        </form>
    </div>
</div>
</body>
</html>
