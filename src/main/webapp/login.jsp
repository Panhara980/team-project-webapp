<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Campus Bulletin &mdash; Sign In</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css" />
</head>
<body>

<div class="login-page">

  <div class="login-blob-1"></div>
  <div class="login-blob-2"></div>
  <div class="login-rule-left"></div>
  <div class="login-rule-right"></div>

  <div class="login-card-wrapper">

    <div class="login-card">
      <div class="login-card__accent-bar"></div>

      <div class="login-card__body">

        <!-- Logo -->
        <div class="login-logo">
          <div class="login-logo__icon">
            <svg width="28" height="28" viewBox="0 0 28 28" fill="none">
              <rect x="4" y="6" width="20" height="16" rx="2" stroke="white" stroke-width="1.8" fill="none"/>
              <path d="M4 11h20" stroke="white" stroke-width="1.8"/>
              <path d="M9 16h6" stroke="white" stroke-width="1.8" stroke-linecap="round"/>
              <path d="M9 19.5h4" stroke="white" stroke-width="1.8" stroke-linecap="round"/>
              <circle cx="22" cy="7" r="3.5" fill="#3B82F6"/>
            </svg>
          </div>
          <h1 class="login-logo__title font-serif">Campus Bulletin</h1>
          <p class="login-logo__sub">Sign in to your university portal</p>
        </div>

        <!-- Server-side error (set as request attribute by the servlet) -->
        <c:if test="${not empty requestScope.errorMessage}">
          <div class="alert-error" style="margin-bottom:16px;">
            <c:out value="${requestScope.errorMessage}"/>
          </div>
        </c:if>

        <!-- Login form — posts to LoginServlet mapped at /login -->
        <form class="login-form" action="${pageContext.request.contextPath}/login" method="post">

          <div class="form-field">
            <label class="form-field__label" for="username">Username or Email</label>
            <input
              class="form-input <c:if test='${not empty requestScope.usernameError}'>error</c:if>"
              type="text"
              id="username"
              name="username"
              value="<c:out value='${not empty param.username ? param.username : ""}'/>  "
              placeholder="e.g. j.chen or prof.smith"
              autocomplete="username"
            />
            <c:if test="${not empty requestScope.usernameError}">
              <span class="form-error-msg"><c:out value="${requestScope.usernameError}"/></span>
            </c:if>
          </div>

          <div class="form-field">
            <label class="form-field__label" for="password">Password</label>
            <input
              class="form-input"
              type="password"
              id="password"
              name="password"
              placeholder="Enter your password"
              autocomplete="current-password"
            />
          </div>

          <!-- Role toggle -->
          <div class="form-field">
            <label class="form-field__label">Sign in as</label>
            <div class="role-toggle">
              <button type="button"
                      class="role-btn <c:if test='${param.role != "professor"}'>active</c:if>"
                      onclick="selectRole('student', this)">Student</button>
              <button type="button"
                      class="role-btn <c:if test='${param.role == "professor"}'>active</c:if>"
                      onclick="selectRole('professor', this)">Professor</button>
            </div>
            <input type="hidden" id="roleInput" name="role"
                   value="${not empty param.role ? param.role : 'student'}" />
          </div>

          <button type="submit" class="btn-primary btn-primary--full" style="margin-top:4px;">
            Sign In
          </button>
        </form>

        <p class="login-demo">
          Demo: <strong>prof.smith</strong> or <strong>j.chen</strong> &middot; any password
        </p>

      </div>
    </div>

    <p class="login-footer">
      &copy; 2026 Campus Bulletin &mdash; University Student Portal
    </p>

  </div>
</div>

<script>
  function selectRole(role, btn) {
    document.querySelectorAll('.role-btn').forEach(function(b) { b.classList.remove('active'); });
    btn.classList.add('active');
    document.getElementById('roleInput').value = role;
  }
</script>

</body>
</html>
