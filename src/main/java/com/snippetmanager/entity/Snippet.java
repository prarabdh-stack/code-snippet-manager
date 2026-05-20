package com.snippetmanager.entity;

// ============================================================
//  Hibernate Annotations — these replace the need for XML mapping
// ============================================================
import javax.persistence.*;
import java.time.LocalDateTime;

/**
 * ENTITY CLASS — Snippet.java
 *
 * This class represents ONE ROW in the 'snippets' table.
 * Hibernate reads these annotations and automatically knows:
 *   - Which table this maps to
 *   - Which field maps to which column
 *   - Which field is the primary key
 *
 * Think of this class as a blueprint that mirrors your DB table.
 */

@Entity                         // Marks this class as a Hibernate-managed entity
@Table(name = "snippets")       // Maps this class to the 'snippets' table in MySQL
public class Snippet {

    // ----------------------------------------------------------
    //  PRIMARY KEY
    //  @Id          → this field is the primary key
    //  @GeneratedValue → MySQL auto-increments it (we never set it manually)
    //  @Column      → maps to the 'id' column in the table
    // ----------------------------------------------------------
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private int id;

    // ----------------------------------------------------------
    //  TITLE — VARCHAR(255) NOT NULL
    //  nullable = false  → Hibernate will enforce this (not null)
    //  length = 255      → matches our VARCHAR(255) in MySQL
    // ----------------------------------------------------------
    @Column(name = "title", nullable = false, length = 255)
    private String title;

    // ----------------------------------------------------------
    //  LANGUAGE — VARCHAR(100) NOT NULL
    //  e.g. "Java", "Python", "C++", "JavaScript"
    // ----------------------------------------------------------
    @Column(name = "language", nullable = false, length = 100)
    private String language;

    // ----------------------------------------------------------
    //  CODE — LONGTEXT
    //  columnDefinition = "LONGTEXT" → tells Hibernate to use
    //  MySQL's LONGTEXT type (supports very large code blocks)
    // ----------------------------------------------------------
    @Column(name = "code", nullable = false, columnDefinition = "LONGTEXT")
    private String code;

    // ----------------------------------------------------------
    //  TAGS — VARCHAR(255), nullable
    //  Stored as a comma-separated string e.g. "array,sorting,DSA"
    // ----------------------------------------------------------
    @Column(name = "tags", length = 255)
    private String tags;

    // ----------------------------------------------------------
    //  CREATED_AT — DATETIME
    //  updatable = false → once set, Hibernate will never update this
    //  insertable = true → Hibernate sets it on INSERT
    //  We use @PrePersist to auto-set it before saving
    // ----------------------------------------------------------
    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;

    // ----------------------------------------------------------
    //  @PrePersist LIFECYCLE HOOK
    //  This method runs automatically BEFORE Hibernate saves
    //  a new Snippet to the database. It sets createdAt to now.
    //  This way we never forget to set the timestamp manually.
    // ----------------------------------------------------------
    @PrePersist
    protected void onCreate() {
        this.createdAt = LocalDateTime.now();
    }

    // ==========================================================
    //  CONSTRUCTORS
    // ==========================================================

    /**
     * No-arg constructor — REQUIRED by Hibernate.
     * Hibernate creates objects using reflection and needs
     * a no-argument constructor to instantiate the class.
     */
    public Snippet() {
    }

    /**
     * Convenience constructor for creating new snippets
     * (without id/createdAt — those are auto-set)
     */
    public Snippet(String title, String language, String code, String tags) {
        this.title    = title;
        this.language = language;
        this.code     = code;
        this.tags     = tags;
    }

    // ==========================================================
    //  GETTERS AND SETTERS
    //  Spring MVC's form binding uses these to populate
    //  the Snippet object from HTML form fields automatically.
    // ==========================================================

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getLanguage() {
        return language;
    }

    public void setLanguage(String language) {
        this.language = language;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getTags() {
        return tags;
    }

    public void setTags(String tags) {
        this.tags = tags;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    // ==========================================================
    //  toString() — useful for debugging in logs
    // ==========================================================
    @Override
    public String toString() {
        return "Snippet{" +
                "id="        + id        +
                ", title='"  + title     + '\'' +
                ", language='"+ language + '\'' +
                ", tags='"   + tags      + '\'' +
                ", createdAt=" + createdAt +
                '}';
    }
}
