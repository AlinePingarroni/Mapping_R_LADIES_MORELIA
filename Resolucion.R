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

# 1. Libreria
library(terra)

# 2.Capas Mares###
# 2.1 Cargar el raster original
mares <- rast("local_NCP_eez_all_targets_md5_7205f1.tif")
ncell(mares)#Ciento treinta y ocho millones novecientos dos mil setecientos setenta y ocho.

# 2.2 Cambiar la resolución (factor de agregación)
# Por ejemplo, si quieres que cada celda sea 4 veces más grande en cada dirección:
factor <- 4
mares_resampled <- aggregate(mares, fact = factor, fun = mean)  # Usamos 'mean' como función de agregación

# 2.3 Verificar el nuevo raster
mares_resampled
ncell(mares_resampled)

# 2. 4 Guardar el raster resultante si es necesario
writeRaster(mares_resampled, "mares_resampled.tif", overwrite = TRUE)

# 3. Tierra####
# 3.1 Cargar el raster original
tierras<-rast("local_NCP_land_all_targets_md5_7ccece.tif")
ncell(tierras)#Ciento treinta y ocho millones novecientos dos mil setecientos setenta y ocho.

# 3.2 Cambiar la resolución (factor de agregación)
# Por ejemplo, si quieres que cada celda sea 4 veces más grande en cada dirección:
factor <- 4
tierras_resampled <- aggregate(tierras, fact = factor, fun = mean)  # Usamos 'mean' como función de agregación

# 3.4 Verificar el nuevo raster
tierras_resampled
ncell(tierras_resampled)

# 3.5 Guardar el raster resultante si es necesario
writeRaster(tierras_resampled, "tierras_resampled.tif", overwrite = TRUE)


# 4.NCPS####
ncps<-rast("local1_global2_overlap3_md5_a0a557.tif")
ncell(ncps)#Ciento treinta y ocho millones novecientos dos mil setecientos setenta y ocho.

# 4.1 Cambiar la resolución
factor <- 4
ncps_resampled <- aggregate(ncps, fact = factor, fun = mean)  # Usamos 'mean' como función de agregación

# 4.2 Verificar el nuevo raster
ncps_resampled
ncell(ncps_resampled)
#4.3 Guardar el raster resultante si es necesario
writeRaster(ncps_resampled, "ncps_resampled.tif", overwrite = TRUE)

