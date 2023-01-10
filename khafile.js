let project = new Project("dreamengine");
project.addAssets("assets/**");
project.addShaders("shaders/**");
project.addSources("src");
resolve(project);