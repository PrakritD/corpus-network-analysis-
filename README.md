# Corpus-Based Document and Token Network Analysis (R)

This repository presents a complete natural language processing (NLP) and network analysis pipeline built in R, exploring semantic and structural relationships between documents using clustering, DTM, and graph analysis.

---

## 📚 Corpus Description

The corpus consists of **16 documents** grouped into **5 distinct topics**, stored in `corpus/`:

| Topic               | Files                         |
|---------------------|-------------------------------|
| 🌌 **Dark Matter**     | dark_matter_1 to dark_matter_5 |
| 🛰 **Mission Overview** | mission_overview_1 to _2       |
| 🎬 **Movie Summaries** | movie_sum_1 to _4              |
| 📰 **Info Articles**    | info_article_1 to _2           |
| 🍕 **NYC Food Reviews** | nyc_food_1 to _3               |

Each file contains at least 100 words and was cleaned and tokenised before analysis.

---

## ⚙️ Pipeline Overview

1. **Text Cleaning**  
   - Quotation mark replacement, punctuation fix, lowercasing, stemming  
2. **Document-Term Matrix (DTM)**  
   - Sparse term removal with 0.4 threshold  
3. **Clustering**  
   - Cosine distance + Ward’s method, visualised as dendrogram  
4. **Networks**  
   - **Single-mode**:
     - Abstract-document adjacency network  
     - Token co-occurrence network  
   - **Two-mode**:
     - Bipartite document–token network  

---

## 📈 Highlights

### ✅ Clustering Accuracy
- 5 clusters mapped to topics with **43.75% accuracy** from confusion matrix.

### 📊 Centrality Metrics
**Document Network**:  
- Most central: `dark_matter_3` (eigenvector), `mission_overview_1` (closeness & betweenness)

**Token Network**:  
- Most central token: `one` (eigenvector), `remain` (closeness)

**Bipartite Network**:  
- `space` emerges as central only in bipartite view, reflecting topic alignment

---

## 📁 Folder Structure

| Folder        | Contents                                          |
|---------------|---------------------------------------------------|
| `corpus/`     | Original 16 `.txt` documents in `corpus/`         |
| `matrices/`   | DTM and adjacency matrices in `.csv` format       |
| `networks/`   | Centrality measures for each graph, and DTMs      |
| `scripts/`    | Reproducible R code (`assignment3_script.R`)      |
| `report/`     | Final PDF report, spec, and export archive        |

---

## ▶️ Run Instructions

```r
# 1. Set working directory
setwd("path/to/scripts")

# 2. Run analysis
source("assignment3_script.R")
