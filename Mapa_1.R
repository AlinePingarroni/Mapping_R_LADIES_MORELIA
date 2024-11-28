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



# Librerías necesarias
library(rnaturalearthdata) # Escalas mayores
library(rnaturalearth)     # Mapas geográficos
library(terra)             # Manipulación de datos raster
library(sf)                # Datos vectoriales espaciales
library(ggplot2)           # Visualización
library(dplyr)             # Manipulación de datos
library(ggnewscale)        # Múltiples escalas de color en ggplot2

# 1. Mapa base del mundo####
world <- ne_countries(scale = "medium", returnclass = "sf")  # Fronteras políticas
world <- ne_download(scale = "medium", type = "land", category = "physical", returnclass = "sf")  # Forma física

# 1.2 Caracteristicas sf
summary(world)
dim(world)
names(world)
class(world)
crs(world, proj = TRUE)#"+proj=longlat +datum=WGS84 +no_defs"

# 1.3 Visualizar el mapa
ggplot(data = world) + 
  geom_sf(fill = NA) +
  theme_minimal()

# 2. Cargar raster NCP de lo mares####
#Cargar rasters
mares<-rast("mares_resampled.tif")
mares
crs(mares, proj = TRUE)#"+proj=longlat +datum=WGS84 +no_defs"

#2.1 Convertir en data frame
df_mares<- as.data.frame(mares, xy = TRUE)
summary(df_mares)
class(df_mares)
names(df_mares)[3] <- "valor_mares"#Renombrar la columna

#2.2 Visualizar raster de mares
ggplot(data = df_mares,aes(x = x, 
                           y = y)) +
  geom_raster(aes(fill = valor_mares))+
  scale_fill_gradientn(colours = c("#deebf7", "#9ecae1", "#3182bd"))

# 3. Cargar raster NCP de tierras####
##Tierras
tierras<-rast("tierras_resampled.tif")
tierras

#3.1 Convertir en data frame
df_tierras<- as.data.frame(tierras, xy = TRUE)
summary(df_tierras)
class(df_tierras)
names(df_tierras)
crs(tierras, proj = TRUE)#"+proj=longlat +datum=WGS84 +no_defs"
names(df_tierras)[3] <- "valor_tierras"# Renombrar la columna

#3.2 Visualizar raster tierras
ggplot(data = df_tierras,aes(x = x, 
                             y = y)) +
  geom_raster(aes(fill = valor_tierras))+
  scale_fill_gradientn(colours = c("#e5f5e0", "#a1d99b", "#31a354"))

#4. Mapas con la paleta de colores correcta####
#4.1 Tierra crear una columna para colores basada en las condiciones
df_tierras <- df_tierras %>%
  mutate(
    color = case_when(
      valor_tierras == 0 ~ NA, # Transparente
      valor_tierras %in% c(1, 2) ~ "gris", # Gris para 1 y 2
      valor_tierras > 2 ~ "verde"# Gradiente verde para valores mayores a 2
    ),
    alpha = ifelse(valor_tierras == 0, 0, 1) # Controlar transparencia
  )

# 4.2 Crear el mapa de tierra
ggplot(data = world,) + 
  geom_sf(fill=NA)+
  # Representar los valores 1 y 2 en gris
  geom_raster(data = df_tierras %>% filter(valor_tierras %in% c(1, 2)),
              aes(x = x, y = y), fill = "#E1E1E1", alpha = 1) +
  # Representar el gradiente verde para valores >2
  geom_raster(data = df_tierras %>% filter(valor_tierras > 2),
              aes(x = x, y = y, fill = valor_tierras)) +
  scale_fill_gradientn(
    colors = c("#E0F3D7", "#5BA161", "#1D3E23"),
    name = "Valores críticos",
    limits = c(3, max(df_tierras$valor_tierras, na.rm = TRUE))
  )+
  theme_void()

# 4.3 Mares-crear una columna para colores basada en las condiciones
df_mares <- df_mares %>%
  mutate(
    color = ifelse(valor_mares == 1, "gris", "azul")
  )

# 4.4 Crear el mapa de mares
ggplot(data = world,) + 
  geom_sf(fill=NA)+
  # Representar los valores de 1 en gris
  geom_tile(data = df_mares %>% filter(valor_mares == 1),
            aes(x = x, y = y), fill = "#E1E1E1") +
  # Representar los valores mayores a 1 en un gradiente azul
  geom_tile(data = df_mares %>% filter(valor_mares > 1),
            aes(x = x, y = y, fill = valor_mares)) +
  scale_fill_gradientn(
    colors = c("#CDDDEF", "#639DCC", "#3468AB"),
    name = "Valor Mares") +
  theme_void() 

# 5. Mapa completo ####
# Crear el mapa combinado
ggplot(data = world) +
  geom_sf(fill = NA, color = "black", linewidth = 0.2) +
  # Primera capa: Tierras
  geom_tile(data = df_tierras %>% filter(valor_tierras %in% c(1, 2)),
            aes(x = x, y = y), fill = "#E1E1E1") +  # Gris para valores 1 y 2
  geom_tile(data = df_tierras %>% filter(valor_tierras > 2),
            aes(x = x, y = y, fill = valor_tierras)) +
  scale_fill_gradientn(
    colors = c("#E0F3D7", "#5BA161", "#1D3E23"),  # Gradiente verde
    guide = "none"  # Sin leyenda para tierras
  ) +
  # TRUCO...Reiniciar la escala de colores
  new_scale_fill() +
  # Segunda capa: Mares
  geom_tile(data = df_mares %>% filter(valor_mares == 1),
            aes(x = x, y = y), fill = "#E1E1E1") +  # Gris para valor 1
  geom_tile(data = df_mares %>% filter(valor_mares > 1),
            aes(x = x, y = y, fill = valor_mares)) +
  scale_fill_gradientn(
    colors = c("#CDDDEF", "#639DCC", "#3468AB"),  # Gradiente azul
    guide = "none"  # Sin leyenda para mares
  ) +
   # Tema limpio
  theme_void()
