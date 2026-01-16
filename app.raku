use Cro::HTTP::Router;
use Cro::HTTP::Server;
use Cro::WebApp::Template;
use DSCI;
use DSCI::HTML;

my $application = route {

  get -> {
    redirect :see-other, "{http-root()}/doc/README";
  }

  get -> 'doc', $thing {
    my $doc-path = "{%*ENV<HOME>}/projects/dsci";
    say "ok";
    template 'templates/thing.crotmp', %( 
      css => css(), 
      navbar => navbar(),
      data => "{$doc-path}/{$thing}.md".IO.slurp, 
      thing => $thing
    )
  }

  #
  # End of API methods
  #

  #
  # Static files methods
  #

  get -> 'js', *@path {
    cache-control :public, :max-age(300);
    static 'js', @path;
  }

  get -> 'css', *@path {
    cache-control :public, :max-age(10);
    static 'css', @path;
  }

  #
  # End of Static files methods
  #

}

my Cro::Service $service = Cro::HTTP::Server.new:
    :host(%*ENV<DT_HOST> || "127.0.0.1"), :port(%*ENV<DT_PORT> || 9292), :$application;

$service.start;

react whenever signal(SIGINT) {
    $service.stop;
    exit;
}

