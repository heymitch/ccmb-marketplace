# 📙 Voice Library

**Source:** Notion Database - The Digital Writer's Voice Lab (How To Train AI To Write Like YOU)
**ID:** 2f8aee68e52f817fbe85faca405c1716
**Data Source URL:** collection://2f8aee68-e52f-81cb-8888-000ba87cc3fe

## Database Overview

The Voice Library is a curated collection of voice examples and training materials for the Digital Writer's Voice Lab course. It serves as the central repository for voice samples, templates, and reference materials used to train AI models to write in a specific author's voice.

## Database Schema

### Properties

#### Name (Title)
- **Type:** Title
- **Description:** The name/title of the voice library entry
- **Required:** Yes

#### Type (Multi-Select)
- **Type:** Multi-Select
- **Description:** Categorization of the library entry
- **Options:**
  - Voice (pink)

### SQLite Definition

```sql
CREATE TABLE IF NOT EXISTS "collection://2f8aee68-e52f-81cb-8888-000ba87cc3fe" (
	url TEXT UNIQUE,
	createdTime TEXT, -- ISO-8601 datetime string, automatically set
	"Type" TEXT, -- JSON array with zero or more of ["Voice"]
	"Name" TEXT
)
```

## Database Views

### All Entries View
- **Name:** (default)
- **Type:** Table
- **Display Properties:** Name, Type
- **Filter:** None (shows all entries)

### Voice View
- **Name:** Voice
- **Type:** Table
- **Display Properties:** Name, Type
- **Filter:** Type contains "Voice"

### Target Audience View
- **Name:** Target Audience
- **Type:** Table
- **Display Properties:** Name, Type
- **Filter:** Type contains "Target Audience"
- **Note:** This view appears configured but the "Target Audience" option is not currently defined in the Type property

## Templates

### {Add New Voice}
- **ID:** 2f8aee68-e52f-816e-803e-ef2ef53177dd
- **Default:** Yes
- **Purpose:** Template for adding new voice entries to the library

## Usage Notes

The Voice Library database is designed to:

1. **Store Voice Samples** - Collect writing examples that demonstrate a particular author's voice and style
2. **Categorize by Type** - Tag entries as "Voice" to organize different voice examples or variations
3. **Support Voice Training** - Provide reference material for AI models learning to replicate a specific writing voice
4. **Enable Filtering** - Allow quick access to specific types of voice entries through saved views

## Course Context

This database is part of the **Digital Writer's Voice Lab** course, which teaches authors how to:
- Define their unique voice
- Document their writing patterns and preferences
- Train AI models (like Claude) to generate content that maintains their voice
- Create consistent brand voice across content platforms

## Access & Integration

- **Access:** Available through Notion workspace with Digital Writer's Voice Lab course access
- **Integration Points:**
  - Voice Tutor skill can reference these entries
  - Course materials can link to specific voice examples
  - AI fine-tuning pipelines can use these as training data
