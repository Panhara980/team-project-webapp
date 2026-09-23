# 📢 Campus Bulletin – Student Notes & Announcement Board

A lightweight, MVC-based Java Enterprise (J2EE) web application designed for universities and academic institutions. This platform allows professors to post study notes and official announcements while enabling students to view and search board updates in real time.

Built as a final term project using pure Enterprise Java technologies (**Servlets, JSP, JDBC, and MySQL**) without heavy external frameworks.

---

## 📸 Key Features

* **Role-Based Authentication (`HttpSession`):**
  * **Professors:** Access permission to create new announcements, manage posts, and delete outdated notes.
  * **Students:** Read-only access to view published announcements and search by subject.
* **Announcement Feed:** Dynamic board rendering all published notes with author info, timestamps, and subject tags.
* **Filter & Search:** Quick search functionality to filter announcements by subject or category.
* **Pure MVC Architecture:** Clean separation of concerns using JavaBeans (Model), Servlets (Controller), and JSP pages (View).

---

## 🛠️ Tech Stack & Prerequisites

* **Language:** Java 8+ / Java Enterprise Edition (EE)
* **Web Server:** Apache Tomcat 9.0+ / 10.0+
* **IDE:** Eclipse IDE for Enterprise Java and Web Developers
* **Database:** MySQL Server 8.0+
* **Libraries/Dependencies:**
  * JDBC Driver (`mysql-connector-j.jar`)
  * JSTL (`jstl-1.2.jar`)

---

## 📁 Project Directory Structure

```text
StudentNotesApp/
├── WebContent/                     <-- Web Root (JSPs, CSS, Assets)
│   ├── css/
│   │   └── style.css               <-- Application Styling
│   ├── login.jsp                   <-- User Authentication View
│   ├── dashboard.jsp               <-- Main Announcement Feed
│   ├── post-note.jsp               <-- Announcement Creation View
│   └── WEB-INF/
│       ├── web.xml                 <-- Deployment Descriptor
│       └── lib/                    <-- MySQL JDBC Driver & JSTL JARs
│
└── src/                            <-- Java Source Files
    └── com/notes/
        ├── util/
        │   └── DBConnection.java   <-- Database Connection Manager
        ├── model/
        │   ├── User.java           <-- User Entity Bean
        │   └── Note.java           <-- Note/Announcement Entity Bean
        ├── dao/
        │   ├── UserDAO.java        <-- User SQL Queries
        │   └── NoteDAO.java        <-- CRUD Operations for Notes
        └── controller/
            ├── LoginServlet.java   <-- Handles Authentication & Sessions
            ├── LogoutServlet.java  <-- Handles Session Invalidation
            ├── PostNoteServlet.java<-- Creates New Announcements
            ├── ViewNotesServlet.java<-- Fetches & Filters Feed Items
            └── DeleteNoteServlet.java<-- Deletes Selected Notes
