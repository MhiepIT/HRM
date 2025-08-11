package com.example.Personnel.Management.Config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebConfig implements WebMvcConfigurer {

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        // Serve static resources (CSS, JS, images, etc.)
        registry.addResourceHandler("/templates/**")
                .addResourceLocations("classpath:/templates/");
        
        registry.addResourceHandler("/static/**")
                .addResourceLocations("classpath:/static/");
        
        // Allow access to root static files
        registry.addResourceHandler("/**")
                .addResourceLocations("classpath:/static/");
    }
}
