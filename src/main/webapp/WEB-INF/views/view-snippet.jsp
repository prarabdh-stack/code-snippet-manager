<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%--
  view-snippet.jsp
  ----------------
  Shows full details of one snippet: title, language, tags, code, date.
  Also shows success/error flash messages (e.g. after an edit redirect).

  Model attributes from Controller:
    ${snippet}        → the Snippet object to display
    ${successMessage} → flash message (e.g. "Snippet updated successfully!")
    ${errorMessage}   → flash error message
--%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>${snippet.title} — Snippet Manager</title>
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

        .container { max-width: 860px; margin: 2.5rem auto; padding: 0 1.5rem; }

        /* Breadcrumb */
        .breadcrumb { font-size: 0.88rem; color: #64748b; margin-bottom: 1.5rem; }
        .breadcrumb a { color: #2563eb; text-decoration: none; }
        .breadcrumb a:hover { text-decoration: underline; }
        .breadcrumb span { margin: 0 0.4rem; }

        /* Alerts */
        .alert { padding: 0.85rem 1.2rem; border-radius: 8px; margin-bottom: 1.2rem; font-size: 0.95rem; }
        .alert-success { background: #dcfce7; color: #166534; border-left: 4px solid #16a34a; }
        .alert-error   { background: #fee2e2; color: #991b1b; border-left: 4px solid #dc2626; }

        /* Card */
        .card { background: #fff; border-radius: 12px; box-shadow: 0 1px 8px rgba(0,0,0,0.09); overflow: hidden; }

        /* Card Header */
        .card-header {
            padding: 1.5rem 2rem;
            border-bottom: 1px solid #f1f5f9;
            display: flex; align-items: flex-start; justify-content: space-between;
            flex-wrap: wrap; gap: 1rem;
        }
        .snippet-title { font-size: 1.5rem; font-weight: 700; color: #1e293b; margin-bottom: 0.5rem; }

        /* Meta row: language badge + tags + date */
        .meta-row { display: flex; align-items: center; flex-wrap: wrap; gap: 0.6rem; }

        .badge { display: inline-block; padding: 0.25rem 0.65rem; border-radius: 20px; font-size: 0.82rem; font-weight: 700; }
        .badge-java       { background: #fef3c7; color: #92400e; }
        .badge-python     { background: #d1fae5; color: #065f46; }
        .badge-javascript { background: #fef9c3; color: #713f12; }
        .badge-cpp        { background: #e0e7ff; color: #3730a3; }
        .badge-default    { background: #f1f5f9; color: #475569; }

        .tag { display: inline-block; background: #f1f5f9; border-radius: 4px; padding: 0.12rem 0.45rem; font-size: 0.8rem; color: #475569; }
        .date-info { font-size: 0.82rem; color: #94a3b8; }

        /* Action buttons in header */
        .header-actions { display: flex; gap: 0.6rem; flex-shrink: 0; }
        .btn { display: inline-block; padding: 0.5rem 1.1rem; border-radius: 7px; font-size: 0.9rem; font-weight: 600; text-decoration: none; cursor: pointer; border: none; transition: opacity 0.2s; }
        .btn:hover { opacity: 0.87; }
        .btn-warning { background: #d97706; color: #fff; }
        .btn-danger  { background: #dc2626; color: #fff; }
        .btn-secondary { background: #e2e8f0; color: #475569; }

        /* Code Block */
        .code-section { padding: 0; }

        .code-toolbar {
            background: #1e293b; padding: 0.6rem 1.5rem;
            display: flex; align-items: center; justify-content: space-between;
            border-top: 1px solid #334155;
        }
        .code-toolbar-label { color: #94a3b8; font-size: 0.82rem; font-family: monospace; }
        .copy-btn {
            background: #334155; color: #cbd5e1; border: none;
            padding: 0.3rem 0.8rem; border-radius: 5px;
            font-size: 0.8rem; cursor: pointer; transition: background 0.2s;
        }
        .copy-btn:hover { background: #475569; color: #fff; }

        /* The actual code display */
        .code-block {
            background: #0f172a;
            color: #e2e8f0;
            padding: 1.5rem;
            font-family: 'Courier New', Courier, monospace;
            font-size: 0.9rem;
            line-height: 1.7;
            overflow-x: auto;
            white-space: pre;           /* preserves spaces and newlines */
            word-break: normal;
            min-height: 200px;
            margin: 0;
        }

        /* No-code fallback */
        .no-code { padding: 2rem; color: #94a3b8; font-style: italic; }
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
        ${snippet.title}
    </div>

    <%-- Flash Messages --%>
    <c:if test="${not empty successMessage}">
        <div class="alert alert-success">&#10003; ${successMessage}</div>
    </c:if>
    <c:if test="${not empty errorMessage}">
        <div class="alert alert-error">&#9888; ${errorMessage}</div>
    </c:if>

    <div class="card">

        <%-- Card Header: title, meta, actions --%>
        <div class="card-header">
            <div>
                <h1 class="snippet-title">${snippet.title}</h1>
                <div class="meta-row">

                    <%-- Language Badge --%>
                    <c:choose>
                        <c:when test="${fn:toLowerCase(snippet.language) eq 'java'}">
                            <span class="badge badge-java">${snippet.language}</span>
                        </c:when>
                        <c:when test="${fn:toLowerCase(snippet.language) eq 'python'}">
                            <span class="badge badge-python">${snippet.language}</span>
                        </c:when>
                        <c:when test="${fn:toLowerCase(snippet.language) eq 'javascript'}">
                            <span class="badge badge-javascript">${snippet.language}</span>
                        </c:when>
                        <c:when test="${fn:toLowerCase(snippet.language) eq 'c++'}">
                            <span class="badge badge-cpp">${snippet.language}</span>
                        </c:when>
                        <c:otherwise>
                            <span class="badge badge-default">${snippet.language}</span>
                        </c:otherwise>
                    </c:choose>

                    <%-- Tags --%>
                    <c:if test="${not empty snippet.tags}">
                        <c:forEach var="tag" items="${fn:split(snippet.tags, ',')}">
                            <span class="tag">${fn:trim(tag)}</span>
                        </c:forEach>
                    </c:if>

                    <%-- Created date --%>
                    <span class="date-info">
                        &#128197; Added: ${fn:substring(snippet.createdAt, 0, 10)}
                    </span>

                </div>
            </div>

            <%-- Edit / Delete Actions --%>
            <div class="header-actions">
                <a href="<c:url value='/snippets/${snippet.id}/edit'/>" class="btn btn-warning">&#9998; Edit</a>
                <a href="<c:url value='/snippets/${snippet.id}/delete'/>"
                   class="btn btn-danger"
                   onclick="return confirm('Delete this snippet permanently?')">
                    &#128465; Delete
                </a>
            </div>
        </div>

        <%-- Code Block Section --%>
        <div class="code-section">
            <div class="code-toolbar">
                <span class="code-toolbar-label">&#128196; ${snippet.language} &mdash; ${snippet.title}</span>
                <%--
                  Copy button uses a small JavaScript function.
                  document.getElementById('codeBlock').innerText gets the raw code text.
                  navigator.clipboard.writeText() copies it to the user's clipboard.
                --%>
                <button class="copy-btn" onclick="copyCode()">&#128203; Copy Code</button>
            </div>

            <%--
              <pre> tag preserves whitespace exactly as stored in DB.
              <c:out value="..."/> is CRITICAL here — it escapes HTML special
              characters like <, >, & so code containing HTML tags displays
              correctly instead of being interpreted as HTML.
            --%>
            <c:choose>
                <c:when test="${not empty snippet.code}">
                    <pre class="code-block" id="codeBlock"><c:out value="${snippet.code}"/></pre>
                </c:when>
                <c:otherwise>
                    <div class="no-code">No code content saved for this snippet.</div>
                </c:otherwise>
            </c:choose>
        </div>

    </div><%-- end .card --%>

</div><%-- end .container --%>

<script>
    /**
     * Copy the code content to the user's clipboard.
     * Uses the modern Clipboard API (supported by all modern browsers).
     */
    function copyCode() {
        var code = document.getElementById('codeBlock').innerText;
        navigator.clipboard.writeText(code).then(function() {
            var btn = document.querySelector('.copy-btn');
            var original = btn.innerText;
            btn.innerText = '✓ Copied!';
            btn.style.background = '#16a34a';
            btn.style.color = '#fff';
            // Reset button text after 2 seconds
            setTimeout(function() {
                btn.innerText = original;
                btn.style.background = '';
                btn.style.color = '';
            }, 2000);
        }).catch(function() {
            alert('Could not copy. Please select and copy manually.');
        });
    }
</script>

</body>
</html>
