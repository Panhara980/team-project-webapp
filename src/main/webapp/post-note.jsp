<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core"      prefix="c"  %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Campus Bulletin &mdash; Post Announcement</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css" />
</head>
<body>

<%--
  Expected session attribute:
    sessionScope.user — object with .displayName (String) and .role (String)
  Expected request attributes (on validation failure):
    requestScope.titleError, requestScope.subjectError, requestScope.contentError
    requestScope.errorMessage
--%>

<%-- Demo fallback: sets a professor session so the page renders standalone --%>
<%
  if (session.getAttribute("user") == null) {
    java.util.Map<String,String> demoUser = new java.util.LinkedHashMap<>();
    demoUser.put("displayName", "Prof. Smith");
    demoUser.put("role", "professor");
    session.setAttribute("user", demoUser);
  }
%>

<c:set var="user" value="${sessionScope.user}"/>

<%-- Redirect students away from this page --%>
<c:if test="${user.role != 'professor'}">
  <c:redirect url="${pageContext.request.contextPath}/dashboard"/>
</c:if>

<div class="post-page">

  <!-- ── Top Nav ── -->
  <header class="topnav">

    <a href="${pageContext.request.contextPath}/dashboard" class="btn-ghost">
      <svg width="14" height="14" viewBox="0 0 20 20" fill="none">
        <path d="M12 4l-7 6 7 6" stroke="currentColor" stroke-width="2"
              stroke-linecap="round" stroke-linejoin="round"/>
      </svg>
      <span class="btn-ghost__label">Back to Dashboard</span>
    </a>

    <div class="divider-v"></div>

    <div class="topnav__logo">
      <div class="topnav__logo-icon">
        <svg width="14" height="14" viewBox="0 0 28 28" fill="none">
          <rect x="4" y="6" width="20" height="16" rx="2" stroke="white" stroke-width="2" fill="none"/>
          <path d="M4 11h20" stroke="white" stroke-width="2"/>
          <circle cx="22" cy="7" r="3.5" fill="#3B82F6"/>
        </svg>
      </div>
      <span class="topnav__logo-text font-serif">Campus Bulletin</span>
    </div>

    <div class="topnav__right">
      <div class="topnav__user">
        <div class="avatar">${fn:substring(user.displayName, 0, 1)}</div>
        <span class="topnav__user-name"><c:out value="${user.displayName}"/></span>
      </div>
    </div>

  </header>

  <!-- ── Page content ── -->
  <div class="post-content">
    <div class="post-inner">

      <div class="post-heading">
        <span class="post-heading__eyebrow">New Announcement</span>
        <h1 class="post-heading__title font-serif">Post an Announcement</h1>
        <p class="post-heading__sub">
          Share course updates, exam schedules, and notices with your students.
        </p>
      </div>

      <c:if test="${not empty requestScope.errorMessage}">
        <div class="alert-error" style="margin-bottom:20px;">
          <c:out value="${requestScope.errorMessage}"/>
        </div>
      </c:if>

      <div class="post-card">
        <form action="${pageContext.request.contextPath}/announcement/create"
              method="post" id="postForm" novalidate>

          <!-- Announcement Title -->
          <div class="form-field">
            <label class="form-field__label" for="annTitle">
              Announcement Title <span class="required">*</span>
            </label>
            <input
              class="form-input <c:if test='${not empty requestScope.titleError}'>error</c:if>"
              type="text"
              id="annTitle"
              name="title"
              value="<c:out value='${param.title}'/>"
              placeholder="e.g. Midterm Exam Schedule &mdash; Fall 2026"
              maxlength="200"
            />
            <c:if test="${not empty requestScope.titleError}">
              <span class="form-error-msg"><c:out value="${requestScope.titleError}"/></span>
            </c:if>
          </div>

          <!-- Subject / Category -->
          <%--
            NOTE: EL array literals like ${['A','B']} require EL 3.0 (Servlet 3.1+).
            Using explicit <option> tags instead for guaranteed Tomcat 11 compatibility.
          --%>
          <div class="form-field">
            <label class="form-field__label" for="annSubject">
              Subject / Category <span class="required">*</span>
            </label>
            <select
              class="form-input <c:if test='${not empty requestScope.subjectError}'>error</c:if>"
              id="annSubject"
              name="subject"
            >
              <option value="" disabled ${empty param.subject ? 'selected' : ''}>
                Select a subject or category&hellip;
              </option>
              <option value="Mathematics"     ${param.subject == 'Mathematics'     ? 'selected' : ''}>Mathematics</option>
              <option value="Science"         ${param.subject == 'Science'         ? 'selected' : ''}>Science</option>
              <option value="General"         ${param.subject == 'General'         ? 'selected' : ''}>General</option>
              <option value="History"         ${param.subject == 'History'         ? 'selected' : ''}>History</option>
              <option value="Computer Science"${param.subject == 'Computer Science'? 'selected' : ''}>Computer Science</option>
              <option value="Literature"      ${param.subject == 'Literature'      ? 'selected' : ''}>Literature</option>
              <option value="Arts"            ${param.subject == 'Arts'            ? 'selected' : ''}>Arts</option>
            </select>
            <c:if test="${not empty requestScope.subjectError}">
              <span class="form-error-msg"><c:out value="${requestScope.subjectError}"/></span>
            </c:if>
          </div>

          <!-- Content / Details -->
          <div class="form-field">
            <div class="form-field__aside">
              <label class="form-field__label" for="annContent">
                Content / Details <span class="required">*</span>
              </label>
              <span class="form-char-count" id="charCount">0 words &middot; 0 chars</span>
            </div>
            <textarea
              class="form-input <c:if test='${not empty requestScope.contentError}'>error</c:if>"
              id="annContent"
              name="content"
              rows="8"
              placeholder="Write the full details of your announcement here. Include relevant dates, locations, requirements, and any important notes for students&hellip;"
            ><c:out value="${param.content}"/></textarea>
            <c:if test="${not empty requestScope.contentError}">
              <span class="form-error-msg"><c:out value="${requestScope.contentError}"/></span>
            </c:if>
          </div>

          <!-- Preview hint (shown by JS once title + subject are filled) -->
          <div class="info-banner" id="previewBanner" style="display:none;">
            <svg width="15" height="15" viewBox="0 0 20 20" fill="none"
                 style="flex-shrink:0;margin-top:1px;">
              <circle cx="10" cy="10" r="7" stroke="#3B82F6" stroke-width="1.6" fill="none"/>
              <path d="M10 9v5M10 7v.5" stroke="#3B82F6" stroke-width="1.6" stroke-linecap="round"/>
            </svg>
            <p>
              Will be posted as <strong><c:out value="${user.displayName}"/></strong>
              under <strong id="previewSubject"></strong>.
            </p>
          </div>

          <!-- Action buttons -->
          <div class="post-actions">
            <button type="submit" class="btn-primary">
              <svg width="13" height="13" viewBox="0 0 20 20" fill="none">
                <path d="M3 10l5 5 9-9" stroke="white" stroke-width="2.2"
                      stroke-linecap="round" stroke-linejoin="round"/>
              </svg>
              Publish Announcement
            </button>
            <a href="${pageContext.request.contextPath}/dashboard" class="btn-secondary">
              Cancel
            </a>
          </div>

        </form>
      </div>

      <!-- Writing tips -->
      <div class="tips-card">
        <p class="tips-card__title">Writing Tips</p>
        <div class="tips-list">
          <div class="tips-list__item">
            <span class="tips-list__dot"></span>
            <span class="tips-list__text">Use a specific title so students can scan the feed quickly.</span>
          </div>
          <div class="tips-list__item">
            <span class="tips-list__dot"></span>
            <span class="tips-list__text">Include exact dates, times, and room numbers where applicable.</span>
          </div>
          <div class="tips-list__item">
            <span class="tips-list__dot"></span>
            <span class="tips-list__text">Keep content concise &mdash; students often read on mobile devices.</span>
          </div>
        </div>
      </div>

    </div>
  </div>
</div>

<script>
  // Live word / char counter
  var textarea  = document.getElementById('annContent');
  var charCount = document.getElementById('charCount');
  function updateCount() {
    var t = textarea.value;
    var w = t.trim() ? t.trim().split(/\s+/).length : 0;
    charCount.textContent = w + ' word' + (w !== 1 ? 's' : '') + ' · ' + t.length + ' chars';
  }
  textarea.addEventListener('input', updateCount);
  updateCount();

  // Preview banner
  var titleInput    = document.getElementById('annTitle');
  var subjectSelect = document.getElementById('annSubject');
  var previewBanner = document.getElementById('previewBanner');
  var previewSubject = document.getElementById('previewSubject');
  function updatePreview() {
    if (titleInput.value.trim() && subjectSelect.value) {
      previewBanner.style.display = 'flex';
      previewSubject.textContent  = subjectSelect.value;
    } else {
      previewBanner.style.display = 'none';
    }
  }
  titleInput.addEventListener('input', updatePreview);
  subjectSelect.addEventListener('change', updatePreview);
  updatePreview();

  // Client-side validation before submit
  document.getElementById('postForm').addEventListener('submit', function(e) {
    var ok = true;
    [titleInput, subjectSelect, textarea].forEach(function(el) { el.classList.remove('error'); });
    if (!titleInput.value.trim())           { titleInput.classList.add('error');    ok = false; }
    if (!subjectSelect.value)               { subjectSelect.classList.add('error'); ok = false; }
    if (textarea.value.trim().length < 20)  { textarea.classList.add('error');      ok = false; }
    if (!ok) e.preventDefault();
  });
</script>

</body>
</html>
