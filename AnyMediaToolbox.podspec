Pod::Spec.new do |s|
    s.name = 'AnyMediaToolbox'
    s.version = '1.2.0'
    s.license = 'MIT'
    s.summary = 'AnyMediaToolbox is a toolbox for CoreMedia Types'
    s.homepage = 'https://github.com/anotheren/AnyMediaToolbox'
    s.authors = {
        'anotheren' => 'liudong.edward@gmail.com',
    }
    s.source = { :git => 'https://github.com/anotheren/AnyMediaToolbox.git', :tag => s.version }
    s.ios.deployment_target = '13.0'
    s.swift_versions = ['5.4']
    s.frameworks = 'Foundation'
    s.source_files = 'Sources/**/*.swift'
end
