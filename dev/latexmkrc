$clean_ext = "brf fdb_latexmk fls ind log lol lox nav out run.xml sbb snm thm tmp tui tuo xmpi";
$clean_full_ext = "hyph";
@generated_exts = qw(acn acr alg aux glg glo gls idx ind ist lof lot out toc);
$pdf_previewer = "start qpdfview --unique";

# For nomenclature
add_cus_dep("nlo", "nls", 0, "nlo2nls");
sub nlo2nls {
  system("makeindex $_[0].nlo -s nomencl.ist -o $_[0].nls -t $_[0].nlg");
}
