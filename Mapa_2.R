# R-Ladies Morelia
# Aprendiendo a hacer mapas en R
# Los datos y la figuras utilizadas provienen del artículo 
# Mapping the planet’s critical natural assets
# https://www.nature.com/articles/s41559-022-01934-5
# Integrantes:
# Aline Pingarroni FES-Iztacala UNAM
# Gabriela Centeno Cabada ENES Morelia
# Quetzally Medina V.Fac. de Ciencias UNAM
# Mariel Guadalupe Gutierrez Chaveste CCM UNAM


# 1. Cargar la librerias
library(rnaturalearthdata) # Escalas mayores
library(rnaturalearth)     
library(terra)
library(ggplot2)
library(sf)  

# 2. Cargar un mapa mundial como capa base
world <- ne_download(scale = "medium", type = "land", category = "physical", returnclass = "sf")  # Forma física

#3. Cargar el raster NCP
ncps <- rast("ncps_resampled.tif")
# Verificar el sistema de coordenadas (CRS) del raster
crs_info <- crs(ncps, proj = TRUE)
print(crs_info)  # Verificamos que esté usando "+proj=longlat +datum=WGS84 +no_defs"

#4. Convertir el raster en un DataFrame para usar con ggplot
df_ncps <- as.data.frame(ncps, xy = TRUE)
summary(df_ncps)# Resumen de las variables en el DataFrame
class(df_ncps)# Verificar la clase del DataFrame
names(df_ncps)
names(df_ncps)[3] <- "valor_ncp"#Renombrar la columna

#5. Ver los valores únicos de la columna del raster
unique(df_ncps$valor_ncp)
df_ncps$valor_ncp <- as.integer(df_ncps$valor_ncp)
unique(df_ncps$valor_ncp)

# Crear el mapa con ggplot
ggplot(world) +
  geom_sf(fill = NA) +  # Añadir la capa base del mapa mundial
  geom_tile(data = df_ncps, 
            aes(x = x, 
                y = y, 
                fill = as.factor(valor_ncp))) +
  scale_fill_manual(
    values = c("#DADADC", "#52A192", "#DE6961", "#F2C211"),  # Mantener el color gris
    name = "Critical nature assets",  # Título de la leyenda
    labels = c("For global (climate) NCP", "For local NCP", "For both"),  # Excluir "NA"
    na.translate = FALSE  # Excluir "NA" de la leyenda pero mantener el color en el mapa
  ) +
  theme_minimal() +
  theme(
    legend.position = c(0.1, 0.15),        # Posición de la leyenda
    legend.justification = c(0, 0),        # Justificación de la leyenda
    legend.background = element_blank(),  # Fondo de la leyenda transparente
    legend.box.background = element_blank()  # Sin fondo de caja para la leyenda
  )
