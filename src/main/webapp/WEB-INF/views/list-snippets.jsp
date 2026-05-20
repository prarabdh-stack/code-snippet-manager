<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Code Snippet Manager</title>

    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f0f2f5;
            color: #333;
            min-height: 100vh;
        }

        .navbar {
            background: #1e293b;
            padding: 0 2rem;
            display: flex;
            align-items: center;
            justify-content: space-between;
            height: 60px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.3);
        }

        .navbar-brand {
            color: #38bdf8;
            font-size: 1.3rem;
            font-weight: 700;
            text-decoration: none;
        }

        .navbar-brand span { color: #fff; }

        .nav-link {
            color: #cbd5e1;
            text-decoration: none;
            padding: 0.4rem 0.9rem;
            border-radius: 6px;
            font-size: 0.9rem;
        }

        .nav-link:hover {
            background: #334155;
            color: #fff;
        }

        .container {
            max-width: 1100px;
            margin: 2rem auto;
            padding: 0 1.5rem;
        }

        .page-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 1.5rem;
            flex-wrap: wrap;
            gap: 1rem;
        }

        .page-title {
            font-size: 1.6rem;
            font-weight: 700;
            color: #1e293b;
        }

        .page-title small {
            font-size: 0.95rem;
            font-weight: 400;
            color: #64748b;
            margin-left: 0.5rem;
        }

        .btn {
            display: inline-block;
            padding: 0.5rem 1.1rem;
            border-radius: 6px;
            font-size: 0.9rem;
            font-weight: 600;
            text-decoration: none;
            cursor: pointer;
            border: none;
        }

        .btn-primary { background: #2563eb; color: #fff; }
        .btn-warning { background: #d97706; color: #fff; }
        .btn-danger { background: #dc2626; color: #fff; }
        .btn-sm { padding: 0.3rem 0.75rem; font-size: 0.8rem; }

        .search-bar {
            display: flex;
            gap: 0.5rem;
            margin-bottom: 1.5rem;
        }

        .search-bar input[type="text"] {
            flex: 1;
            padding: 0.55rem 1rem;
            border: 1.5px solid #cbd5e1;
            border-radius: 6px;
            font-size: 0.95rem;
        }

        .search-bar button {
            padding: 0.55rem 1.2rem;
            background: #2563eb;
            color: #fff;
            border: none;
            border-radius: 6px;
            font-weight: 600;
            cursor: pointer;
        }

        .clear-btn {
            padding: 0.55rem 1rem;
            background: #e2e8f0;
            color: #475569;
            border-radius: 6px;
            text-decoration: none;
            font-weight: 600;
        }

        .alert {
            padding: 0.85rem 1.2rem;
            border-radius: 8px;
            margin-bottom: 1.2rem;
            font-size: 0.95rem;
            font-weight: 500;
        }

        .alert-success {
            background: #dcfce7;
            color: #166534;
            border-left: 4px solid #16a34a;
        }

        .alert-error {
            background: #fee2e2;
            color: #991b1b;
            border-left: 4px solid #dc2626;
        }

        .search-info {
            background: #eff6ff;
            border: 1px solid #bfdbfe;
            border-radius: 8px;
            padding: 0.7rem 1rem;
            margin-bottom: 1rem;
            font-size: 0.9rem;
            color: #1d4ed8;
        }

        .table-wrapper {
            background: #fff;
            border-radius: 10px;
            box-shadow: 0 1px 6px rgba(0,0,0,0.08);
            overflow: hidden;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            font-size: 0.92rem;
        }

        thead {
            background: #1e293b;
            color: #e2e8f0;
        }

        thead th {
            padding: 0.9rem 1rem;
            text-align: left;
            font-weight: 600;
        }

        tbody tr {
            border-bottom: 1px solid #f1f5f9;
        }

        tbody tr:hover {
            background: #f8fafc;
        }

        tbody td {
            padding: 0.85rem 1rem;
            vertical-align: middle;
        }

        .badge {
            display: inline-block;
            padding: 0.25rem 0.65rem;
            border-radius: 20px;
            font-size: 0.78rem;
            font-weight: 700;
        }

        .badge-java { background: #fef3c7; color: #92400e; }
        .badge-python { background: #d1fae5; color: #065f46; }
        .badge-javascript { background: #fef9c3; color: #713f12; }
        .badge-cpp { background: #e0e7ff; color: #3730a3; }
        .badge-default { background: #f1f5f9; color: #475569; }

        .tag {
            display: inline-block;
            background: #f1f5f9;
            border-radius: 4px;
            padding: 0.1rem 0.4rem;
            margin: 0.1rem;
            font-size: 0.78rem;
            color: #475569;
        }

        .action-buttons {
            display: flex;
            gap: 0.4rem;
            flex-wrap: wrap;
        }

        .empty-state {
            text-align: center;
            padding: 4rem 2rem;
            color: #94a3b8;
        }

        .empty-state .icon {
            font-size: 3.5rem;
            margin-bottom: 1rem;
        }

        .date-cell {
            color: #94a3b8;
            font-size: 0.82rem;
            white-space: nowrap;
        }
    </style>
</head>

<body>

<nav class="navbar">
    <a href="<c:url value='/snippets'/>" class="navbar-brand">
        &lt;/&gt; <span>Snippet Manager</span>
    </a>

    <a href="<c:url value='/snippets/new'/>" class="nav-link">
        + New Snippet
    </a>
</nav>

<div class="container">

    <div class="page-header">
        <h1 class="page-title">
            My Snippets
            <small>${fn:length(snippets)} snippet(s)</small>
        </h1>

        <a href="<c:url value='/snippets/new'/>" class="btn btn-primary">
            + Add New Snippet
        </a>
    </div>

    <c:if test="${not empty successMessage}">
        <div class="alert alert-success">
            ${successMessage}
        </div>
    </c:if>

    <c:if test="${not empty errorMessage}">
        <div class="alert alert-error">
            ${errorMessage}
        </div>
    </c:if>

    <form class="search-bar" action="<c:url value='/snippets/search'/>" method="get">
        <input type="text"
               name="keyword"
               placeholder="Search by title or language..."
               value="${keyword}"/>

        <button type="submit">Search</button>

        <c:if test="${not empty keyword}">
            <a href="<c:url value='/snippets'/>" class="clear-btn">Clear</a>
        </c:if>
    </form>

    <c:if test="${not empty keyword}">
        <div class="search-info">
            Found <strong>${resultCount}</strong> result(s) for
            "<strong>${keyword}</strong>"
        </div>
    </c:if>

    <c:choose>

        <c:when test="${not empty snippets}">

            <div class="table-wrapper">
                <table>
                    <thead>
                    <tr>
                        <th>#</th>
                        <th>Title</th>
                        <th>Language</th>
                        <th>Tags</th>
                        <th>Created</th>
                        <th>Actions</th>
                    </tr>
                    </thead>

                    <tbody>
                    <c:forEach var="s" items="${snippets}" varStatus="loop">
                        <tr>
                            <td>${loop.count}</td>

                            <td>
                                <a href="<c:url value='/snippets/${s.id}'/>"
                                   style="color:#2563eb; font-weight:600; text-decoration:none;">
                                    ${s.title}
                                </a>
                            </td>

                            <td>
                                <c:choose>
                                    <c:when test="${fn:toLowerCase(s.language) eq 'java'}">
                                        <span class="badge badge-java">${s.language}</span>
                                    </c:when>

                                    <c:when test="${fn:toLowerCase(s.language) eq 'python'}">
                                        <span class="badge badge-python">${s.language}</span>
                                    </c:when>

                                    <c:when test="${fn:toLowerCase(s.language) eq 'javascript'}">
                                        <span class="badge badge-javascript">${s.language}</span>
                                    </c:when>

                                    <c:when test="${fn:toLowerCase(s.language) eq 'c++'}">
                                        <span class="badge badge-cpp">${s.language}</span>
                                    </c:when>

                                    <c:otherwise>
                                        <span class="badge badge-default">${s.language}</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>

                            <td>
                                <c:choose>
                                    <c:when test="${not empty s.tags}">
                                        <c:forEach var="tag" items="${fn:split(s.tags, ',')}">
                                            <span class="tag">${tag}</span>
                                        </c:forEach>
                                    </c:when>

                                    <c:otherwise>
                                        <span style="color:#cbd5e1;">—</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>

                            <td class="date-cell">
                                ${s.createdAt}
                            </td>

                            <td>
                                <div class="action-buttons">
                                    <a href="<c:url value='/snippets/${s.id}'/>"
                                       class="btn btn-primary btn-sm">
                                        View
                                    </a>

                                    <a href="<c:url value='/snippets/${s.id}/edit'/>"
                                       class="btn btn-warning btn-sm">
                                        Edit
                                    </a>

                                    <a href="<c:url value='/snippets/${s.id}/delete'/>"
                                       class="btn btn-danger btn-sm"
                                       onclick="return confirm('Delete this snippet?')">
                                        Delete
                                    </a>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>

        </c:when>

        <c:otherwise>
            <div class="table-wrapper">
                <div class="empty-state">
                    <div class="icon">📄</div>

                    <c:choose>
                        <c:when test="${not empty keyword}">
                            <h3>No snippets found for "${keyword}"</h3>
                            <p>Try a different search term or clear the search.</p>

                            <a href="<c:url value='/snippets'/>" class="btn btn-primary">
                                View All Snippets
                            </a>
                        </c:when>

                        <c:otherwise>
                            <h3>No snippets yet!</h3>
                            <p>Start building your personal code library.</p>

                            <a href="<c:url value='/snippets/new'/>" class="btn btn-primary">
                                + Add Your First Snippet
                            </a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </c:otherwise>

    </c:choose>

</div>

</body>
</html>