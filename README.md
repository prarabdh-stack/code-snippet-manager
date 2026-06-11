# Code Snippet Manager

A Java-based web application for storing, managing, and organizing reusable code snippets.

The project is built using **Spring MVC**, **Hibernate**, **JSP**, **MySQL**, and **Maven**. It follows a layered architecture with separate Controller, Service, DAO, and Model layers.

## Overview

Code Snippet Manager helps users save frequently used code snippets in one place.

Each snippet can contain details such as title, programming language, code content, tags, and creation date. The application provides basic CRUD operations for managing snippets through a simple web interface.

This project helped me understand Java web development, MVC architecture, Hibernate ORM, database integration, and Maven-based project management.

## Features

* Add new code snippets
* View saved snippets
* Update existing snippets
* Delete unwanted snippets
* Store snippet details in MySQL
* Organize snippets using title, language, and tags
* Simple JSP-based user interface
* Layered architecture using Controller, Service, DAO, and Model layers

## Tech Stack

* Java
* Spring MVC
* Hibernate ORM
* JSP
* Servlet
* MySQL
* Maven
* Apache Tomcat

## Project Structure

```txt
Code-Snippet-Manager/
│
├── src/
│   └── main/
│       ├── java/
│       │   └── com/
│       │       └── snippetmanager/
│       │           ├── controller/
│       │           ├── dao/
│       │           ├── model/
│       │           └── service/
│       │
│       ├── resources/
│       │   └── hibernate.cfg.xml
│       │
│       └── webapp/
│           ├── WEB-INF/
│           │   ├── views/
│           │   └── web.xml
│           └── static/
│
├── pom.xml
└── README.md
```

## How It Works

The application follows the MVC architecture.

The user interacts with JSP pages. Requests are handled by Spring MVC controllers. Business logic is managed through the service layer, and database operations are handled through the DAO layer using Hibernate.

The basic workflow is:

```txt
JSP Pages
    ↓
Spring MVC Controller
    ↓
Service Layer
    ↓
DAO Layer
    ↓
Hibernate ORM
    ↓
MySQL Database
```

## Database Setup

Create a MySQL database:

```sql
CREATE DATABASE snippet_manager_db;
```

Update your database credentials in the Hibernate configuration file:

```xml
<property name="hibernate.connection.url">
    jdbc:mysql://localhost:3306/snippet_manager_db
</property>

<property name="hibernate.connection.username">your_username</property>
<property name="hibernate.connection.password">your_password</property>
```

## How to Run Locally

1. Clone the repository:

```bash
git clone https://github.com/your-username/code-snippet-manager.git
```

2. Move into the project folder:

```bash
cd code-snippet-manager
```

3. Open the project in IntelliJ IDEA or any Java IDE.

4. Configure MySQL database.

5. Update the database credentials in `hibernate.cfg.xml`.

6. Build the project using Maven:

```bash
mvn clean install
```

7. Deploy the generated WAR file on Apache Tomcat.

8. Start the Tomcat server.

9. Open the application in your browser:

```txt
http://localhost:8080/code-snippet-manager
```

## Maven Build

To clean and build the project, run:

```bash
mvn clean install
```

The WAR file will be generated inside the `target/` folder.

## Security Note

Database usernames, passwords, and other sensitive configuration values should not be committed publicly to GitHub.

Use safer methods such as:

* Environment variables
* Local configuration files ignored by Git
* Placeholder credentials in public configuration files

Example `.gitignore` entries:

```gitignore
target/
.idea/
*.iml
.env
```

## Future Improvements

* Add user authentication
* Add syntax highlighting for code snippets
* Add search and filter functionality
* Add pagination
* Add REST API support
* Improve UI design
* Add snippet categories
* Add export and import functionality

## Learning Outcomes

Through this project, I learned about:

* Building Java web applications
* Using Spring MVC architecture
* Working with Hibernate ORM
* Connecting Java applications with MySQL
* Creating layered application structure
* Managing dependencies with Maven
* Deploying a WAR file on Apache Tomcat
* Handling CRUD operations in a Java web project

## Conclusion

Code Snippet Manager is a Java web application that helps users store and manage reusable code snippets.

It demonstrates the use of Spring MVC, Hibernate, JSP, MySQL, Maven, and Apache Tomcat in a structured web application.
