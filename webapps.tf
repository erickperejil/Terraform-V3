resource "azurerm_service_plan" "sp_frontoffice" {
    name = "sp-frontoffice-${ var.project }-${var.environment}"
    location = var.location
    resource_group_name = data.azurerm_resource_group.rg.name
    sku_name = "B1"
    os_type = "Linux"
}

resource "azurerm_service_plan" "sp_backoffice" {
    name = "sp-backoffice-${ var.project }-${var.environment}"
    location = var.location
    resource_group_name = data.azurerm_resource_group.rg.name
    sku_name = "B1"
    os_type = "Linux"
}

resource "azurerm_service_plan" "sp_functions" {
    name = "sp-functions-${ var.project }-${var.environment}"
    location = var.location
    resource_group_name = data.azurerm_resource_group.rg.name
    sku_name = "B1"
    os_type = "Linux"
}

resource "azurerm_linux_web_app" "web_app_ssr_cliente" {
  name                = "ssr-cliente-${var.project}-${var.environment}"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg.name
  service_plan_id     = azurerm_service_plan.sp_frontoffice.id

  //definir el metodo deployment de la app
  site_config {
    always_on = true
    application_stack {                               //bajo asp, phyton, node, docker..
      docker_registry_url = "https://index.docker.io" //pull de las imagenes de docker con los contenedores
      docker_image_name   = "my-next-app:latest"            //imagen asociada a la webapp
    }
  }

  //variables environment que se decidieron en la webapp
  app_settings = {
    WEBSITES_PORT = "80"
  }

  tags = var.tags
}


resource "azurerm_linux_web_app" "web_ui_backoffice" {
  name                = "ui-backoffice-${var.project}-${var.environment}"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg.name
  service_plan_id     = azurerm_service_plan.sp_backoffice.id

  //definir el metodo deployment de la app
  site_config {
    always_on = true
    application_stack {                               //bajo asp, phyton, node, docker..
      docker_registry_url = "https://index.docker.io" //pull de las imagenes de docker con los contenedores
      docker_image_name   = "nginx:latest"            //imagen asociada a la webapp
    }
  }

  //variables environment que se decidieron en la webapp
  app_settings = {
    WEBSITES_PORT = "80"
  }

  tags = var.tags
}

resource "azurerm_linux_web_app" "web_api_backoffice" {
  name                = "api-backoffice-${var.project}-${var.environment}"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg.name
  service_plan_id     = azurerm_service_plan.sp_backoffice.id

  //definir el metodo deployment de la app
  site_config {
    always_on = true
    application_stack {                               //bajo asp, phyton, node, docker..
      docker_registry_url = "https://index.docker.io" //pull de las imagenes de docker con los contenedores
      docker_image_name   = "fastapi:latest"            //imagen asociada a la webapp
    }
  }

  //variables environment que se decidieron en la webapp
  app_settings = {
    WEBSITES_PORT = "80"
  }

  tags = var.tags
}

