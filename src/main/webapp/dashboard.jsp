<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core"      prefix="c"   %>
<%@ taglib uri="jakarta.tags.fmt"       prefix="fmt" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn"  %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Campus Bulletin &mdash; Dashboard</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css" />
</head>
<body>

<%-- Demo fallback: remove once your servlet is wired up --%>
<%
  if (session.getAttribute("user") == null) {
    java.util.Map<String,String> demoUser = new java.util.LinkedHashMap<>();
    demoUser.put("displayName", "Prof. Smith");
    demoUser.put("role", "professor");
    session.setAttribute("user", demoUser);
  }
  if (request.getAttribute("filteredAnnouncements") == null) {
    java.util.List<java.util.Map<String,String>> list = new java.util.ArrayList<>();
    String[][] rows = {
      {"1","Midterm Exam Schedule — Fall 2026","General",
       "The midterm examination schedule for Fall 2026 has been finalized. All exams will be held in the main examination hall. Students must bring their university ID cards.",
       "Prof. Eleanor Hayes","Sep 5, 2026"},
      {"2","Calculus II — Problem Set 4 Released","Mathematics",
       "Problem Set 4 covering integration by parts and improper integrals is now available. Due date is September 15th. Office hours extended to Tuesday 3–5 PM.",
       "Prof. David Kim","Sep 4, 2026"},
      {"3","Lab Safety Briefing — Mandatory Attendance","Science",
       "All students in CHEM 201, BIO 102, and PHYS 150 must attend the annual lab safety briefing on September 10th at 2:00 PM in Lecture Hall B.",
       "Prof. Maria Santos","Sep 3, 2026"},
      {"4","Library Extended Hours During Finals","General",
       "The university library will extend its hours to 24/7 starting October 1st through finals week. Quiet study rooms can be reserved online up to 48 hours in advance.",
       "Prof. James Okafor","Sep 2, 2026"},
      {"5","Physics Workshop: Quantum Mechanics Intro","Science",
       "An introductory workshop on quantum mechanics for third-year students on September 12th. Covers wave-particle duality and the Schrödinger equation. Seats limited.",
       "Prof. Linda Zhao","Sep 1, 2026"},
      {"6","Mathematics Olympiad — Campus Qualifier","Mathematics",
       "The annual Mathematics Olympiad campus qualifier will take place on September 20th. Any student in Year 2 or above is eligible to participate.",
       "Prof. David Kim","Aug 30, 2026"}
    };
    for (String[] r : rows) {
      java.util.Map<String,String> m = new java.util.LinkedHashMap<>();
      m.put("id", r[0]); m.put("title", r[1]); m.put("subject", r[2]);
      m.put("contentPreview", r[3]); m.put("authorName", r[4]); m.put("formattedDate", r[5]);
      list.add(m);
    }
    request.setAttribute("announcements", list);
    request.setAttribute("filteredAnnouncements", list);
  }
%>

<c:set var="user"           value="${sessionScope.user}"/>
<c:set var="isProfessor"    value="${sessionScope.user.role == 'professor'}"/>
<c:set var="activeCategory" value="${not empty param.category ? param.category : 'All'}"/>
<c:set var="searchQuery"    value="${not empty param.q ? param.q : ''}"/>

<!-- Sidebar overlay (mobile) -->
<div class="sidebar-overlay" id="sidebarOverlay" onclick="closeSidebar()"></div>

<!-- ── Top Nav ── -->
<header class="topnav">

  <!-- Hamburger (mobile only) -->
  <button class="topnav__hamburger" id="hamburgerBtn"
          onclick="openSidebar()" aria-label="Open menu">
    <svg width="18" height="18" viewBox="0 0 20 20" fill="none">
      <path d="M3 5h14M3 10h14M3 15h14" stroke="currentColor"
            stroke-width="1.8" stroke-linecap="round"/>
    </svg>
  </button>

  <!-- Logo -->
  <div class="topnav__logo">
    <div class="topnav__logo-icon">
      <svg width="17" height="17" viewBox="0 0 28 28" fill="none">
        <rect x="4" y="6" width="20" height="16" rx="2" stroke="white" stroke-width="2" fill="none"/>
        <path d="M4 11h20" stroke="white" stroke-width="2"/>
        <path d="M9 16h6" stroke="white" stroke-width="2" stroke-linecap="round"/>
        <circle cx="22" cy="7" r="3.5" fill="#3B82F6"/>
      </svg>
    </div>
    <span class="topnav__logo-text font-serif">Campus Bulletin</span>
  </div>

  <!-- Search (hidden on mobile — shown in mobile-search bar below) -->
  <div class="topnav__search-wrap">
    <form action="${pageContext.request.contextPath}/dashboard" method="get"
          style="position:relative;">
      <c:if test="${not empty param.category}">
        <input type="hidden" name="category" value="${param.category}"/>
      </c:if>
      <svg class="topnav__search-icon" width="14" height="14" viewBox="0 0 20 20" fill="none">
        <circle cx="8.5" cy="8.5" r="5.5" stroke="#94A3B8" stroke-width="1.8"/>
        <path d="M13 13l4 4" stroke="#94A3B8" stroke-width="1.8" stroke-linecap="round"/>
      </svg>
      <input class="topnav__search" type="search" name="q"
             value="<c:out value='${searchQuery}'/>"
             placeholder="Filter by subject, title, or keyword&hellip;"
             autocomplete="off"/>
    </form>
  </div>

  <!-- User + logout -->
  <div class="topnav__right">
    <div class="topnav__user">
      <div class="avatar <c:if test='${not isProfessor}'>avatar--blue</c:if>">
        ${fn:substring(user.displayName, 0, 1)}
      </div>
      <div>
        <div class="topnav__user-name">Welcome, <c:out value="${user.displayName}"/></div>
        <div class="topnav__user-role"><c:out value="${user.role}"/></div>
      </div>
    </div>
    <div class="divider-v"></div>
    <form action="${pageContext.request.contextPath}/logout" method="post" style="margin:0;">
      <button type="submit" class="btn-logout">Logout</button>
    </form>
  </div>

</header>

<!-- Mobile search bar (below topnav, only visible on small screens) -->
<div class="mobile-search">
  <form action="${pageContext.request.contextPath}/dashboard" method="get">
    <c:if test="${not empty param.category}">
      <input type="hidden" name="category" value="${param.category}"/>
    </c:if>
    <svg class="topnav__search-icon" width="14" height="14" viewBox="0 0 20 20" fill="none">
      <circle cx="8.5" cy="8.5" r="5.5" stroke="#94A3B8" stroke-width="1.8"/>
      <path d="M13 13l4 4" stroke="#94A3B8" stroke-width="1.8" stroke-linecap="round"/>
    </svg>
    <input type="search" name="q"
           value="<c:out value='${searchQuery}'/>"
           placeholder="Search announcements&hellip;"
           autocomplete="off"/>
  </form>
</div>

<!-- ── Dashboard Layout ── -->
<div class="dashboard-layout">

  <!-- Sidebar (off-canvas on mobile) -->
  <aside class="sidebar" id="sidebar">

    <!-- Close button (mobile only) -->
    <div style="display:flex;align-items:center;justify-content:space-between;margin-bottom:8px;">
      <div style="display:flex;align-items:center;gap:8px;">
        <div class="topnav__logo-icon" style="width:28px;height:28px;border-radius:7px;">
          <svg width="13" height="13" viewBox="0 0 28 28" fill="none">
            <rect x="4" y="6" width="20" height="16" rx="2" stroke="white" stroke-width="2" fill="none"/>
            <path d="M4 11h20" stroke="white" stroke-width="2"/>
            <circle cx="22" cy="7" r="3.5" fill="#3B82F6"/>
          </svg>
        </div>
        <span class="font-serif" style="font-size:14px;color:#1E3A8A;">Menu</span>
      </div>
      <button onclick="closeSidebar()"
              style="width:28px;height:28px;border-radius:7px;border:1px solid #E2E8F0;
                     background:transparent;display:flex;align-items:center;
                     justify-content:center;color:#475569;cursor:pointer;"
              aria-label="Close menu">
        <svg width="14" height="14" viewBox="0 0 20 20" fill="none">
          <path d="M5 5l10 10M15 5L5 15" stroke="currentColor" stroke-width="1.8"
                stroke-linecap="round"/>
        </svg>
      </button>
    </div>

    <div>
      <p class="sidebar__section-label">Navigation</p>
      <nav class="sidebar__nav">
        <a href="${pageContext.request.contextPath}/dashboard"
           class="sidebar__nav-btn ${empty param.category and empty param.myPosts ? 'active' : ''}">
          <svg width="14" height="14" viewBox="0 0 20 20" fill="none">
            <rect x="2" y="3" width="16" height="3" rx="1" fill="currentColor"/>
            <rect x="2" y="8.5" width="16" height="3" rx="1" fill="currentColor"/>
            <rect x="2" y="14" width="10" height="3" rx="1" fill="currentColor"/>
          </svg>
          All Announcements
        </a>
        <c:if test="${isProfessor}">
          <a href="${pageContext.request.contextPath}/dashboard?myPosts=true"
             class="sidebar__nav-btn ${not empty param.myPosts ? 'active' : ''}">
            <svg width="14" height="14" viewBox="0 0 20 20" fill="none">
              <path d="M3 17l3-1 9-9-2-2-9 9-1 3z" stroke="currentColor"
                    stroke-width="1.6" fill="none" stroke-linejoin="round"/>
              <path d="M13 5l2 2" stroke="currentColor" stroke-width="1.6"
                    stroke-linecap="round"/>
            </svg>
            My Posts
          </a>
        </c:if>
      </nav>
    </div>

    <div>
      <p class="sidebar__section-label">Category</p>
      <nav class="sidebar__nav">

        <c:set var="totalCount" value="${fn:length(requestScope.announcements)}"/>
        <a href="${pageContext.request.contextPath}/dashboard"
           class="sidebar__cat-btn ${activeCategory == 'All' ? 'active' : ''}">
          <span class="sidebar__dot" style="background:#94A3B8;"></span>
          <span style="flex:1;">All</span>
          <span class="sidebar__count">${totalCount}</span>
        </a>

        <c:set var="mathCount" value="0"/>
        <c:forEach var="ann" items="${requestScope.announcements}">
          <c:if test="${ann.subject == 'Mathematics'}">
            <c:set var="mathCount" value="${mathCount + 1}"/>
          </c:if>
        </c:forEach>
        <a href="${pageContext.request.contextPath}/dashboard?category=Mathematics"
           class="sidebar__cat-btn ${activeCategory == 'Mathematics' ? 'active' : ''}">
          <span class="sidebar__dot" style="background:#3B82F6;"></span>
          <span style="flex:1;">Mathematics</span>
          <span class="sidebar__count">${mathCount}</span>
        </a>

        <c:set var="sciCount" value="0"/>
        <c:forEach var="ann" items="${requestScope.announcements}">
          <c:if test="${ann.subject == 'Science'}">
            <c:set var="sciCount" value="${sciCount + 1}"/>
          </c:if>
        </c:forEach>
        <a href="${pageContext.request.contextPath}/dashboard?category=Science"
           class="sidebar__cat-btn ${activeCategory == 'Science' ? 'active' : ''}">
          <span class="sidebar__dot" style="background:#22C55E;"></span>
          <span style="flex:1;">Science</span>
          <span class="sidebar__count">${sciCount}</span>
        </a>

        <c:set var="genCount" value="0"/>
        <c:forEach var="ann" items="${requestScope.announcements}">
          <c:if test="${ann.subject == 'General'}">
            <c:set var="genCount" value="${genCount + 1}"/>
          </c:if>
        </c:forEach>
        <a href="${pageContext.request.contextPath}/dashboard?category=General"
           class="sidebar__cat-btn ${activeCategory == 'General' ? 'active' : ''}">
          <span class="sidebar__dot" style="background:#F97316;"></span>
          <span style="flex:1;">General</span>
          <span class="sidebar__count">${genCount}</span>
        </a>

      </nav>
    </div>

    <c:if test="${isProfessor}">
      <a href="${pageContext.request.contextPath}/post-note"
         class="btn-primary" style="text-align:center;margin-top:auto;">
        <svg width="13" height="13" viewBox="0 0 20 20" fill="none">
          <path d="M10 4v12M4 10h12" stroke="white" stroke-width="2.2" stroke-linecap="round"/>
        </svg>
        Post Announcement
      </a>
    </c:if>

    <div class="sidebar__footer" style="margin-top:${isProfessor ? '0' : 'auto'};">
      <p>Fall 2026 Semester</p>
      <p>${totalCount} announcement<c:if test="${totalCount != 1}">s</c:if></p>
    </div>

  </aside><!-- /.sidebar -->

  <!-- Feed -->
  <main class="feed">

    <div class="feed__header">
      <div>
        <h2 class="feed__title font-serif">
          <c:choose>
            <c:when test="${not empty param.myPosts}">My Posts</c:when>
            <c:when test="${activeCategory == 'All'}">All Announcements</c:when>
            <c:otherwise><c:out value="${activeCategory}"/></c:otherwise>
          </c:choose>
        </h2>
        <p class="feed__subtitle">
          ${fn:length(requestScope.filteredAnnouncements)}
          result<c:if test="${fn:length(requestScope.filteredAnnouncements) != 1}">s</c:if>
          <c:if test="${not empty searchQuery}">
            for &ldquo;<c:out value="${searchQuery}"/>&rdquo;
          </c:if>
        </p>
      </div>
      <c:if test="${isProfessor}">
        <a href="${pageContext.request.contextPath}/post-note" class="btn-primary">
          <svg width="13" height="13" viewBox="0 0 20 20" fill="none">
            <path d="M10 4v12M4 10h12" stroke="white" stroke-width="2.2" stroke-linecap="round"/>
          </svg>
          Post New Announcement
        </a>
      </c:if>
    </div>

    <!-- Cards -->
    <c:choose>
      <c:when test="${empty requestScope.filteredAnnouncements}">
        <div class="empty-state">
          <div class="empty-state__icon">
            <svg width="24" height="24" viewBox="0 0 20 20" fill="none">
              <rect x="3" y="4" width="14" height="12" rx="2"
                    stroke="#3B82F6" stroke-width="1.6" fill="none"/>
              <path d="M6 8h8M6 11h5" stroke="#3B82F6"
                    stroke-width="1.6" stroke-linecap="round"/>
            </svg>
          </div>
          <p class="empty-state__title">No announcements found</p>
          <p class="empty-state__sub">Try adjusting your filters or search query</p>
        </div>
      </c:when>
      <c:otherwise>
        <div class="cards-grid">
          <c:forEach var="ann" items="${requestScope.filteredAnnouncements}">

            <c:set var="badgeClass" value="badge--default"/>
            <c:if test="${ann.subject == 'Mathematics'}">      <c:set var="badgeClass" value="badge--math"/></c:if>
            <c:if test="${ann.subject == 'Science'}">          <c:set var="badgeClass" value="badge--science"/></c:if>
            <c:if test="${ann.subject == 'General'}">          <c:set var="badgeClass" value="badge--general"/></c:if>
            <c:if test="${ann.subject == 'Computer Science'}"> <c:set var="badgeClass" value="badge--cs"/></c:if>
            <c:if test="${ann.subject == 'History'}">          <c:set var="badgeClass" value="badge--history"/></c:if>
            <c:if test="${ann.subject == 'Literature'}">       <c:set var="badgeClass" value="badge--lit"/></c:if>
            <c:if test="${ann.subject == 'Arts'}">             <c:set var="badgeClass" value="badge--arts"/></c:if>

            <div class="ann-card">
              <div class="ann-card__top">
                <div class="ann-card__meta">
                  <span class="badge ${badgeClass}"><c:out value="${ann.subject}"/></span>
                  <span class="ann-card__date"><c:out value="${ann.formattedDate}"/></span>
                </div>
                <c:if test="${isProfessor}">
                  <form action="${pageContext.request.contextPath}/announcement/delete"
                        method="post" style="margin:0;"
                        onsubmit="return confirm('Delete this announcement?');">
                    <input type="hidden" name="id" value="${ann.id}"/>
                    <button type="submit" class="btn-danger-ghost" title="Delete">
                      <svg width="14" height="14" viewBox="0 0 20 20" fill="none">
                        <path d="M4 6h12M8 6V4h4v2M7 6l1 10h4l1-10"
                              stroke="currentColor" stroke-width="1.6"
                              stroke-linecap="round" stroke-linejoin="round"/>
                      </svg>
                    </button>
                  </form>
                </c:if>
              </div>

              <h3 class="ann-card__title"><c:out value="${ann.title}"/></h3>
              <p  class="ann-card__body"><c:out value="${ann.contentPreview}"/></p>

              <div class="ann-card__footer">
                <div class="avatar" style="width:24px;height:24px;font-size:10px;">
                  ${fn:substring(ann.authorName, 0, 1)}
                </div>
                <span class="ann-card__author-name">
                  Posted by <strong><c:out value="${ann.authorName}"/></strong>
                </span>
              </div>
            </div>

          </c:forEach>
        </div>
      </c:otherwise>
    </c:choose>

  </main><!-- /.feed -->
</div><!-- /.dashboard-layout -->

<script>
  function openSidebar() {
    document.getElementById('sidebar').classList.add('open');
    document.getElementById('sidebarOverlay').classList.add('open');
    document.body.style.overflow = 'hidden';
  }

  function closeSidebar() {
    document.getElementById('sidebar').classList.remove('open');
    document.getElementById('sidebarOverlay').classList.remove('open');
    document.body.style.overflow = '';
  }

  // Close sidebar on Escape key
  document.addEventListener('keydown', function(e) {
    if (e.key === 'Escape') closeSidebar();
  });
</script>

</body>
</html>
