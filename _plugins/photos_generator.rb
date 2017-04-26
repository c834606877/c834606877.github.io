module Jekyll
  class PhotosPage < Page
    def initialize(site, base, dir)
      @site = site
      @base = base
      @dir = dir
      @name = 'index.html'
      self.process(@name)
      self.read_yaml(base, 'photos.html')
      #self.data['category'] = category
    end
  end

  class PhotosPageGenerator < Generator
    safe true

    def generate(site)
            dir = 'photos'
            site.pages << PhotosPage.new(site, site.source, dir)

    end
  end

end
