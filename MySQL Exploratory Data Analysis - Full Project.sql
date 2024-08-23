-- Exploratory Data Analysis


-- 1. Display all columns from the layoffs_staging2 table
SELECT *
FROM layoffs_staging2
;

-- 2. Find the maximum values for total_laid_off and percentage_laid_off
SELECT MAX(total_laid_off) AS max_total_laid_off, MAX(percentage_laid_off) AS max_percentage_laid_off
FROM layoffs_staging2
;

-- 3. Retrieve companies where percentage_laid_off is 100%, ordered by funds raised (descending)
SELECT company, total_laid_off, percentage_laid_off, funds_raised_millions
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC
;

-- 4. Summarize total laid off by company, ordered by total laid off (descending)
SELECT company, SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
GROUP BY company
ORDER BY total_laid_off DESC
;

-- 5. Find the earliest and latest dates in the dataset
SELECT MIN(`date`) AS earliest_date, MAX(`date`) AS latest_date
FROM layoffs_staging2
;

-- 6. Summarize total laid off by country, ordered by total laid off (descending)
SELECT country, SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
GROUP BY country
ORDER BY total_laid_off DESC
;

-- 7. Display all columns from the layoffs_staging2 table (repeated from above)
SELECT *
FROM layoffs_staging2
;

-- 8. Summarize total laid off by year, ordered by year (descending)
SELECT YEAR(`date`) AS year, SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY year DESC
;

-- 9. Summarize total laid off by stage, ordered by total laid off (descending)
SELECT stage, SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
GROUP BY stage
ORDER BY total_laid_off DESC
;

-- 10. Summarize percentage laid off by company, ordered by total percentage laid off (descending)
SELECT company, SUM(percentage_laid_off) AS total_percentage_laid_off
FROM layoffs_staging2
GROUP BY company
ORDER BY total_percentage_laid_off DESC
;

-- 11. Summarize total laid off by month, ordered by month (ascending)
SELECT SUBSTRING(`date`, 1, 7) AS month, SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY month
ORDER BY month ASC
;

-- 12. Compute rolling total of laid off employees by month
WITH Rolling_Total AS
(
    SELECT SUBSTRING(`date`, 1, 7) AS month, SUM(total_laid_off) AS total_off
    FROM layoffs_staging2
    WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
    GROUP BY month
    ORDER BY month ASC
)
SELECT month, 
       total_off,
       SUM(total_off) OVER(ORDER BY month) AS rolling_total
FROM Rolling_Total
;

-- 13. Summarize total laid off by company, ordered by total laid off (descending) (repeated from above)
SELECT company, SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
GROUP BY company
ORDER BY total_laid_off DESC
;

-- 14. Summarize total laid off by company and year, ordered by total laid off (descending)
SELECT company, YEAR(`date`) AS year, SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
ORDER BY total_laid_off DESC
;

-- 15. Rank companies by total laid off per year and retrieve top 5 for each year
WITH Company_Year AS
(
    SELECT company, YEAR(`date`) AS year, SUM(total_laid_off) AS total_laid_off
    FROM layoffs_staging2
    GROUP BY company, YEAR(`date`)
),
Company_Year_Rank AS 
(
    SELECT *, DENSE_RANK() OVER(PARTITION BY year ORDER BY total_laid_off DESC) AS ranking
    FROM Company_Year
    WHERE year IS NOT NULL
)
SELECT company, year, total_laid_off, ranking
FROM Company_Year_Rank
WHERE ranking <= 5
;





























