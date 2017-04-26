module Jekyll
  class AudiosPage < Page
    def initialize(site, base, dir)
      @site = site
      @base = base
      @dir = dir
      @name = 'index.html'
      self.process(@name)
      self.read_yaml(base, 'audios.html')
      #self.data['category'] = category
    end
  end

  class AudiosPageGenerator < Generator
    safe true

    def generate(site)
            dir = 'audios'
            site.pages << AudiosPage.new(site, site.source, dir)

    end
  end

end
