#!/usr/bin/perl

# Find story content based on a storyid.

# user variables
$webRoot = "/var/www/html";
$cmbHome = "/cmb/www/index.html";
$dbuser = "webster";
$dbname = "cmb";
$dbaddress = "localhost";

# Invoke needed library modules
use CGI;
use DBI;
use CGI::Lite;

# Limit command path
($ENV{'PATH'} = '/bin:/usr/bin:/usr/local/bin'); # =~ s/\s*,\s*/:/g;

# Retrieve parameters from (lower-cased) GET/POST query string
$ENV{'QUERY_STRING'} =~ tr/A-Z/a-z/ if defined $ENV{QUERY_STRING};
$query = new CGI;
$storyid = $query->param('id');

# Set up database access
$database = "DBI:Pg:dbname=$dbname;host=$dbaddress";
$dbh = DBI->connect("$database", $dbuser) or die $DBI::errstr;

# Query database for event name
$sql = "SELECT featureid FROM story WHERE storyid=$storyid";
$sth = $dbh->prepare("$sql");
$sth->execute or die "Couldn't execute storyid query\n";
$featureid = $sth->fetchrow_array;
$sql = "SELECT name FROM feature WHERE featureid=$featureid";
$sth = $dbh->prepare("$sql");
$sth->execute or die "Couldn't execute featureid query\n";
$eventname = $sth->fetchrow_array;

# Query database for matching content

$sql = "SELECT htmlfile,mediafile,starthtmlfile,startmediafile,";
$sql .= "endhtmlfile,endmediafile FROM content ";
$sql .= "WHERE storyid=$storyid";
$sth = $dbh->prepare("$sql");
$sth->execute or die "Couldn't execute storyid query\n";


# Present these to user as a web page
print "Content-Type: text/html\n\n";
print "<html>\n<head>\n";
print "  <meta name=\"featureid\" content=\"$featureid\"/>\n";
print "  <meta name=\"storyid\" content=\"$storyid\"/>\n";
print "  <link href=\"../story.css\" rel=\"stylesheet\" type=\"text/css\">\n";
print "  <title>Matching Events</title>\n  </head>\n";
print "<body>\n";
print "<h1>$eventname</h1>\n";

print "<table width=\"85%\" border=\"0\" cellspacing=\"6\" cellpadding=\"0\">\n";
 
while (@row = $sth->fetchrow_array) {
	($htmlfile,$mediafile,$starthtmlfile,$startmediafile,$endhtmlfile,$endmediafile) = @row;
	
	print "<tr><td>\n";
	if ($startmediafile) {
		$f = substr($startmediafile, length($webRoot));
		print "<img src=\"$f\" border=2 borderColor=\"#666666\"></td>\n";
	} else {
		print "&nbsp;</td>\n";
	}
	$text = readFile($starthtmlfile);
	print "<td valign=\"top\" >" . url_decode($text) . "</td>\n</tr>\n";

	print "<tr><td>\n";
	if ($mediafile) {
		$f = substr($mediafile, length($webRoot));
		print "<img src=\"$f\" border=2 borderColor=\"#666666\"></td>\n";
	} else {
		print "&nbsp;</td>\n";
	}
	$text = readFile($htmlfile);
	print "<td valign=\"top\" >" . url_decode($text) . "</td>\n</tr>\n";

	print "<tr><td>\n";
	if ($endmediafile) {
		$f = substr($endmediafile, length($webRoot));
		print "<img src=\"$f\" border=2 borderColor=\"#666666\"></td>\n";
	} else {
		print "&nbsp;</td>\n";
	}
	$text = readFile($endhtmlfile);
	print "<td valign=\"top\" >" . url_decode($text) . "</td>\n</tr>\n";
}
print "</table>\n";
print "<br><br>\n";
print "<a href=\"$cmbHome\">Home</a>\n";
print "</body>\n</html>\n";

sub readFile() {
	$fn = pop @_;
	$t = "";
	open(INFILE, $fn);
	# request an exclusive lock on the file.
	flock(INFILE, LOCK_EX);
	# read in each line from the file
	while (<INFILE>) {
		# $_ is the line that <INFILE> has set.
		$t .= $_;
	}
	# unlock the file.
	flock(INFILE, LOCK_UN);
	close(INFILE);
	return $t;
}
