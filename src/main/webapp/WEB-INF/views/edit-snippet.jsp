<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--
  edit-snippet.jsp
  ----------------
  Pre-filled form to edit an existing snippet.
  On submit → POST /snippets/update → SnippetController.updateSnippet()

  Model attributes from Controller:
    ${snippet}       → the existing Snippet object (fields pre-filled)
    ${errorMessage}  → validation error flash (if redirected back)

  KEY DIFFERENCE from add-snippet.jsp:
    1. Action points to /snippets/update (not /snippets/save)
    2. A hidden field carries the snippet's ID so the Controller
       knows WHICH snippet to update.
    3. All fields are pre-filled with existing values using ${snippet.xxx}
--%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Edit: ${snippet.title} — Snippet Manager</title>
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
        .nav-link { color: #cbd5e1; text-decoration: none; padding: 0.4rem 0.9rem; border-radius: 6px; font-size: 0.9rem; }
        .nav-link:hover { background: #334155; color: #fff; }

        .container { max-width: 780px; margin: 2.5rem auto; padding: 0 1.5rem; }

        /* Breadcrumb */
        .breadcrumb { font-size: 0.88rem; color: #64748b; margin-bottom: 1.5rem; }
        .breadcrumb a { color: #2563eb; text-decoration: none; }
        .breadcrumb a:hover { text-decoration: underline; }
        .breadcrumb span { margin: 0 0.4rem; }

        /* Card */
        .card { background: #fff; border-radius: 12px; box-shadow: 0 1px 8px rgba(0,0,0,0.09); padding: 2rem; }
        .card-title { font-size: 1.4rem; font-weight: 700; color: #1e293b; margin-bottom: 0.4rem; }
        .card-subtitle { color: #64748b; font-size: 0.9rem; margin-bottom: 1.8rem; }

        /* Edit notice banner */
        .edit-notice {
            background: #fffbeb; border: 1px solid #fde68a;
            border-radius: 8px; padding: 0.75rem 1rem;
            font-size: 0.88rem; color: #92400e; margin-bottom: 1.5rem;
        }

        /* Alerts */
        .alert { padding: 0.85rem 1.2rem; border-radius: 8px; margin-bottom: 1.5rem; font-size: 0.95rem; }
        .alert-error { background: #fee2e2; color: #991b1b; border-left: 4px solid #dc2626; }

        /* Form */
        .form-group { margin-bottom: 1.4rem; }
        .form-row { display: grid; grid-template-columns: 1fr 1fr; gap: 1rem; }

        label { display: block; font-size: 0.88rem; font-weight: 600; color: #374151; margin-bottom: 0.4rem; }
        label .required { color: #dc2626; margin-left: 2px; }
        label .hint { font-weight: 400; color: #94a3b8; font-size: 0.82rem; }

        input[type="text"], select, textarea {
            width: 100%; padding: 0.6rem 0.9rem;
            border: 1.5px solid #cbd5e1; border-radius: 7px;
            font-size: 0.95rem; font-family: inherit;
            outline: none; transition: border-color 0.2s;
            color: #1e293b; background: #fff;
        }
        input[type="text"]:focus,
        select:focus,
        textarea:focus { border-color: #2563eb; box-shadow: 0 0 0 3px rgba(37,99,235,0.1); }

        .code-area {
            font-family: 'Courier New', Courier, monospace;
            font-size: 0.9rem; line-height: 1.6;
            min-height: 260px; resize: vertical;
            background: #0f172a; color: #e2e8f0; border-color: #334155;
        }
        .code-area:focus { border-color: #38bdf8; box-shadow: 0 0 0 3px rgba(56,189,248,0.15); }

        .field-hint { font-size: 0.8rem; color: #94a3b8; margin-top: 0.3rem; }

        /* Buttons */
        .form-actions { display: flex; gap: 0.8rem; margin-top: 1.8rem; flex-wrap: wrap; }
        .btn { display: inline-block; padding: 0.6rem 1.4rem; border-radius: 7px; font-size: 0.95rem; font-weight: 600; text-decoration: none; cursor: pointer; border: none; transition: opacity 0.2s; }
        .btn:hover { opacity: 0.87; }
        .btn-warning   { background: #d97706; color: #fff; }
        .btn-secondary { background: #e2e8f0; color: #475569; }
        .btn-outline   { background: transparent; color: #2563eb; border: 1.5px solid #2563eb; }
    </style>
</head>
<body>

<%-- NAVBAR --%>
<nav class="navbar">
    <a href="<c:url value='/snippets'/>" class="navbar-brand">&lt;/&gt; <span>Snippet Manager</span></a>
    <a href="<c:url value='/snippets/${snippet.id}'/>" class="nav-link">&#8592; Back to Snippet</a>
</nav>

<div class="container">

    <%-- Breadcrumb --%>
    <div class="breadcrumb">
        <a href="<c:url value='/snippets'/>">Snippets</a>
        <span>&#8250;</span>
        <a href="<c:url value='/snippets/${snippet.id}'/>">${snippet.title}</a>
        <span>&#8250;</span>
        Edit
    </div>

    <%-- Error Flash Message --%>
    <c:if test="${not empty errorMessage}">
        <div class="alert alert-error">&#9888; ${errorMessage}</div>
    </c:if>

    <div class="card">
        <h1 class="card-title">&#9998; Edit Snippet</h1>
        <p class="card-subtitle">Update the details of your saved snippet.</p>

        <%-- Edit notice --%>
        <div class="edit-notice">
            &#9888; You are editing: <strong>${snippet.title}</strong>
            (ID: ${snippet.id}) — changes are saved immediately on submit.
        </div>

        <%--
          FORM — posts to /snippets/update
          The hidden field 'id' is the most important difference from add-snippet.jsp.
          Without it, the Controller would receive a Snippet with id=0
          and Hibernate wouldn't know which row to UPDATE.
        --%>
        <form action="<c:url value='/snippets/update'/>" method="post">

            <%--
              HIDDEN FIELD — carries the snippet ID through the form submission.
              The browser doesn't show this to the user, but it IS sent with
              the POST request. Spring MVC maps it to snippet.setId(...)
              via @ModelAttribute, so Hibernate knows which row to update.
            --%>
            <input type="hidden" name="id" value="${snippet.id}"/>

            <%-- Row 1: Title + Language --%>
            <div class="form-row">

                <div class="form-group">
                    <label for="title">
                        Title <span class="required">*</span>
                    </label>
                    <input type="text"
                           id="title"
                           name="title"
                           value="${snippet.title}"
                           maxlength="255"
                           required/>
                </div>

                <div class="form-group">
                    <label for="language">Language <span class="required">*</span></label>
                    <%--
                      ${snippet.language eq 'Java' ? 'selected' : ''}
                      This is a JSP EL ternary expression.
                      It compares the current snippet's language to each option
                      and adds the 'selected' HTML attribute to the matching one.
                      This is how we PRE-SELECT the correct dropdown option.
                    --%>
                    <select id="language" name="language" required>
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

            </div>

            <%-- Row 2: Code textarea (pre-filled with existing code) --%>
            <div class="form-group">
                <label for="code">
                    Code <span class="required">*</span>
                    <span class="hint">(edit your code below)</span>
                </label>
                <%--
                  <c:out value="${snippet.code}"/> inside the textarea.
                  c:out ESCAPES special HTML characters:
                    <  becomes &lt;
                    >  becomes &gt;
                    &  becomes &amp;
                  This is CRITICAL — without it, code containing HTML tags
                  would break the JSP page layout.
                --%>
                <textarea id="code"
                          name="code"
                          class="code-area"
                          required><c:out value="${snippet.code}"/></textarea>
                <div class="field-hint">Preserves indentation and formatting.</div>
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
                       value="${snippet.tags}"
                       maxlength="255"
                       placeholder="e.g. array, sorting, DSA"/>
                <div class="field-hint">Separate multiple tags with commas.</div>
            </div>

            <%-- Form Actions --%>
            <div class="form-actions">
                <button type="submit" class="btn btn-warning">&#10003; Update Snippet</button>
                <a href="<c:url value='/snippets/${snippet.id}'/>" class="btn btn-secondary">Cancel</a>
                <a href="<c:url value='/snippets'/>" class="btn btn-outline">Back to List</a>
            </div>

        </form>
    </div>
</div>
</body>
</html>
