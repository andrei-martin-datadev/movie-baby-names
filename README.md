# 🎬 movie-baby-names

**The Hollywood Effect: How Actor Names Shape Baby Naming Trends**

This project explores the intersection of film and culture by asking a simple but fascinating question:  
**Can the popularity of actor names in movies influence what parents name their children?**

## 📌 Overview

Inspired by my two best friends named Diana — both born in 1981, the year of Princess Diana’s wedding — this analysis investigates whether names of prominent actors in films correlate with baby name spikes in the United States. 

The hypothesis: **cultural visibility of a name through film actors may lead to sharp increases in baby name usage.**

While both actor and character names were explored, **character names were ultimately excluded** from the clustering model due to limited predictive power. Actor names yielded significantly stronger associations.

## 🔍 Datasets Used

- **U.S. Baby Names (through 2014)**  
  Includes yearly name counts by gender, normalised by total births.

- **IMDb Film Data (since 1912)**  
  Processed for English-language movies, top 3 billed actors, and character names.

All datasets were merged and cleaned via an SQL stored procedure which utilises three SQL functions.

> 🔧 See: film.sp_dataprep.sql, ExtractNumbers, ConvertNonBasicLatinToBasic, HasNonAlphabeticChar

## 🧠 Methodology

### 1. **Feature Engineering**
We constructed features to capture media presence and baby name trends:
- `Actor_Rate`: share of actor name mentions in a given year
- `Actor_Rate_Lag1/2/3`: lagged media presence
- `Actor_Rise`: a reappearance flag based on gaps in prior actor mentions
- `Is_Baby_Spike`: boolean flag for steep baby name increases
- `Spike_Type`: categorised as *steep spike*, *regular spike*, or *none*

### 2. **Unsupervised Clustering**
Using **KMeans**, names were clustered *without using baby name outcomes*, relying solely on actor-based features. This ensured an unbiased grouping of names by their **media prominence over time**.

Spike labels were then used **post-clustering** for interpretation, not model training.

### 3. **Validation**
Clusters were analysed to determine whether they coincided with higher baby name spikes. Several names — such as *Deanna*, *Brenda*, *Joan*, and *Miley* — strongly aligned with cultural or media-driven moments.

> 📊 Future work includes a Tableau dashboard and Medium blog post showcasing key visualisations.

## 📂 Repository Structure

| File | Description |
|------|-------------|
| `unsupervised_clustering_baby_names.ipynb` | Full Python notebook with feature engineering, clustering, and result interpretation |
| `film.sp_dataprep.sql` | SQL stored procedure for merging and preparing the dataset |
| `dbo.HasNonAlphabeticChar.sql`<br>`dbo.ConvertNonBasicLatinToBasic.sql`<br>`dbo.ExtractNumbers.sql` | SQL helper functions for data cleaning |
| `actorbabycharacternames.zip` | Zipped version of the cleansed dataset (not committed if >25MB) |

## 🔧 Tools and Technologies

- Python (pandas, matplotlib, scikit-learn)
- T-SQL (for cleaning and preparation)
- Jupyter Notebooks
- GitHub
- Tableau (planned)

## 🧾 License

This project is licensed under the **MIT License** — see [LICENSE](LICENSE) for details.

## ✍️ Author

**Andrei Martin Diamante**  
Data & Business Analytics Specialist | Educator | Cultural Observer  
Connect via [GitHub](https://github.com/andrei-martin-datadev)

---

## ⭐ Coming Soon

- 📊 **Interactive Tableau Dashboard**
- 📝 **Medium article** unpacking the full story, visuals, and cultural analysis

