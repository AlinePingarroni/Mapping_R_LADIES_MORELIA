# Creación de Mapas en R

## Participantes

- **Aline Pingarroni** (FES-Iztacala UNAM)  
- **Gabriela Centeno Cabada** (ENES Morelia)  
- **Quetzally Medina V.** (Fac. de Ciencias UNAM)  
- **Mariel Guadalupe Gutierrez Chaveste** (CCM UNAM)

**R-Ladies Morelia** - Taller: Aprendiendo a hacer mapas en R.  
Los datos y las figuras utilizadas provienen del artículo *Mapping the planet’s critical natural assets* ([Nature](https://www.nature.com/articles/s41559-022-01934-5)).

---

## Descripción General

Este repositorio contiene scripts desarrollados para crear mapas en R basados en datos espaciales raster y vectoriales. Los scripts incluyen pasos para la manipulación de datos geográficos y su visualización utilizando diversas librerías especializadas.

---

## 1. Scripts Incluidos

### 1.1 Script: `Mapa1`
Este script combina datos vectoriales y raster para generar mapas que muestran contribuciones de la naturaleza en tierra y mar. Contiene:

- **Librerías utilizadas**: 
  - `rnaturalearthdata`, `rnaturalearth`: Mapas base del mundo.
  - `terra`, `sf`: Manipulación de datos raster y vectoriales.
  - `ggplot2`, `ggnewscale`: Visualización de mapas y control de escalas.
  - `dplyr`: Transformación de datos.

- **Pasos principales**:
  1. Carga de un mapa base del mundo.
  2. Carga y procesamiento de datos raster (mares y tierras).
  3. Conversión de rasters a data frames para visualización.
  4. Creación de mapas con colores personalizados y condiciones específicas.
  5. Mapa combinado de mares y tierras.

---

### 1.2 Script: `Mapa2`
Este script crea un mapa basado en datos raster que representan activos naturales críticos (`Critical Nature Assets`). Contiene:

- **Librerías utilizadas**: 
  - `rnaturalearth`, `terra`, `sf`, `ggplot2`.

- **Pasos principales**:
  1. Carga de un mapa base mundial.
  2. Procesamiento de un raster (`ncps_resampled`) para representar activos naturales críticos.
  3. Conversión del raster a data frame y ajuste de valores.
  4. Visualización del mapa utilizando paletas de colores específicas.

---

### 1.3 Script: `Resolución`
Este script se enfoca en la reducción de resolución espacial de rasters para optimizar su uso y visualización. Contiene:

- **Librerías utilizadas**: 
  - `terra`.

- **Pasos principales**:
  1. Carga de datos raster para mares, tierras y activos naturales críticos.
  2. Ajuste de la resolución de los rasters mediante un factor de agregación (`aggregate()`).
  3. Guardado de los rasters procesados para su uso posterior.

---

## 2. Datos

### Archivos Raster:
1. **`mares_resampled.tif`**: Datos raster de contribuciones de la naturaleza en mares, con resolución ajustada.
2. **`tierras_resampled.tif`**: Datos raster de contribuciones de la naturaleza en tierras, con resolución ajustada.
3. **`ncps_resampled.tif`**: Datos combinados de contribuciones locales y globales (solapamientos).

### Mapas Vectoriales:
- Mapas base del mundo obtenidos mediante las librerías `rnaturalearth` y `rnaturalearthdata`.

---

## 3. Visualizaciones

### Mapas Incluidos:
1. **Mapas individuales**:
   - Mapa de mares con gradiente azul.
   - Mapa de tierras con gradiente verde.
2. **Mapa combinado**:
   - Integración de mares y tierras en un único mapa, utilizando escalas de color separadas.

---

## 4. Requisitos

- R versión ≥ 4.0.
- Librerías instaladas:
  - `rnaturalearthdata`, `rnaturalearth`, `terra`, `sf`, `ggplot2`, `dplyr`, `ggnewscale`.

Para instalar las librerías necesarias, ejecuta:
```R
install.packages(c("rnaturalearthdata", "rnaturalearth", "terra", "sf", "ggplot2", "dplyr", "ggnewscale"))
