#!/usr/bin/perl

use if $^O eq "MSWin32", Win32::Console::ANSI;
use Getopt::Long;
use HTTP::Request;
use HTTP::Response;
use HTTP::Headers;
use HTTP::Request::Common qw(POST);
use HTTP::Request::Common qw(GET);
use IO::Select;
use IO::Socket;
use IO::Socket::INET;
use Term::ANSIColor;
use URI::URL;
use Data::Dumper;
use LWP::UserAgent;
use LWP::Simple;
use JSON qw( decode_json encode_json );

my $ua = LWP::UserAgent->new;
$ua = LWP::UserAgent->new(keep_alive => 1);
$ua->agent("Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.31 (KHTML, like Gecko) Chrome/26.0.1410.63 Safari/537.31");

GetOptions(
    "h|help" => \$help,
    "i|info=s" => \$info,
    "w|whois=s" => \$whois,
    "l|location=s" => \$geo,
    "p|port=s" => \$op,
    "s|subdomain=s" => \$sub,
    "r|reverseip=s" => \$rev,
    "t|tech=s" => \$tech,
    "c|cloudflare=s" => \$cloud,
    "cms|cms=s" => \$cms,
);

if ($help) { banner();help(); }
if ($info) { banner();Websiteinformation(); }
if ($whois) { banner();Domainwhoislookup(); }
if ($geo) { banner();Findiplocation(); }
if ($op) { banner();port(); }
if ($sub) { banner();subdomain(); }
if ($rev) { banner();revip();}
if ($tech) { banner();Technology();}
if ($cloud) { banner();CloudFlare(); }
if ($cms) { banner();cms(); }
unless ($help|$info|$whois|$geo|$op|$sub|$rev|$tech|$cloud|$cms) { banner();menu(); }

#--------------------------------------------------------------#
#                            Help                              #
#--------------------------------------------------------------#
sub help {
    print line_u(),color('bold cyan'),"#                   ";
    print item('1'),"Website Information ";
    print color('bold red'),"=> ";
    print color("bold white"),"reconwolf -i site.com";
    print color('bold cyan'),"                   #   \n";

    print color('bold cyan'),"#                   ";
    print item('2'),"Domain Whois Lookup ";
    print color('bold red'),"=> ";
    print color("bold white"),"reconwolf -w site.com";
    print color('bold cyan'),"                   #   \n";

    print color('bold cyan'),"#                   ";
    print item('3'),"Find IP Location ";
    print color('bold red'),"   => ";
    print color("bold white"),"reconwolf -l site.com";
    print color('bold cyan'),"                   #   \n";

    print color('bold cyan'),"#                   ";
    print item('4'),"Active Port Scanner";
    print color('bold red')," => ";
    print color("bold white"),"reconwolf -p site.com/127.0.0.1";
    print color('bold cyan'),"         #   \n";

    print color('bold cyan'),"#                   ";
    print item('5'),"Subdomain Scanner ";
    print color('bold red'),"  => ";
    print color("bold white"),"reconwolf -s site.com";
    print color('bold cyan'),"                   #   \n";

    print color('bold cyan'),"#                   ";
    print item('6'),"Reverse IP Lookup ";
    print color('bold red'),"  => ";
    print color("bold white"),"reconwolf -r site.com";
    print color('bold cyan'),"                   #   \n";

    print color('bold cyan'),"#                   ";
    print item('7'),"Technology lookup ";
    print color('bold red'),"  => ";
    print color("bold white"),"reconwolf -t site.com";
    print color('bold cyan'),"                   #   \n";

    print color('bold cyan'),"#                   ";
    print item('8'),"Bypass CloudFlare ";
    print color('bold red'),"  => ";
    print color("bold white"),"reconwolf -c site.com";
    print color('bold cyan'),"                   #   \n";

    print color('bold cyan'),"#                   ";
    print item('9'),"CMS Scanner ";
    print color('bold red'),"        => ";
    print color("bold white"),"reconwolf -cms site.com";
    print color('bold cyan'),"                 #   \n",line_d();
}

#--------------------------------------------------------------#
#                           Banner                             #
#--------------------------------------------------------------#
sub banner {
    if ($^O =~ /MSWin32/) {system("mode con: cols=130 lines=40");system("cls"); }else { system("resize -s 40 130");system("clear"); }


print color('bold red'),"                                                                                               ,/{}\n";
print color('bold red'),"                                                                                             ,/  {|\n";
print color('bold red'),"                                                                                         ,,,/    {|,\n";
print color('bold red'),"                                                                                   __--~~        {| ~-,\n";
print color('bold red'),"                                                                             __--~~              {     `\\\n";
print color('bold red'),"                                                                                                     ,__ \\\n";
print color('bold red'),"                                                                                                    `,\\{),\\,\n";
print color('bold green'),"  /#######                                            /##      /##           /##  /######   ";print color('bold red'),"      __-~  `_ ~-_\n";
print color('bold green')," | ##__  ##                                          | ##  /# | ##          | ## /##__  ##  ";print color('bold red'),"   _-~        ~~-_`~-_\n";
print color('bold green')," | ##  \\ ##  /######   /#######  /######  /#######   | ## /###| ##  /###### | ##| ##  \\__/  ";print color('bold red'),"   '               `~-_`~-__\n";
print color('bold green')," | #######/ /##__  ## /##_____/ /##__  ##| ##__  ##  | ##/## ## ## /##__  ##| ##| ####      ";print color('bold red'),"   `,                  `~-\\_|\n";
print color('bold green')," | ##__  ##| ########| ##      | ##  \\ ##| ##  \\ ##  | ####_  ####| ##  \\ ##| ##| ##_/      ";print color('bold red'),"    `,      _-----___    _,'\n";
print color('bold green')," | ##  \\ ##| ##_____/| ##      | ##  | ##| ##  | ##  | ###/ \\  ###| ##  | ##| ##| ##        ";print color('bold red'),"    / /--__  ~~--__  `~,~\n";
print color('bold green')," | ##  | ##|  #######|  #######|  ######/| ##  | ##  | ##/   \\  ##|  ######/| ##| ##        ";print color('bold red'),"     /     ~~--__  ~-',\n";
print color('bold green')," |__/  |__/ \\_______/ \\_______/ \\______/ |__/  |__/  |__/     \\__/ \\______/ |__/|__/        ";print color('bold red'),"    /            ~~--'\n\n";
                   
                   






                                                                                          


print color('bold cyan'),"               #---------------------------------------------------------# \n"; 
print color('bold cyan'),"               # ";print color('bold white'),"                     By XyberWolf         "; print color('bold cyan'),"              # \n"; 
print color('bold cyan'),"               #---------------------------------------------------------# \n\n"; 


}

#--------------------------------------------------------------#
#                             Menu                             #
#--------------------------------------------------------------#
sub menu {
    print line_u(),color('bold cyan'),"#                              ";print color('reset'),item('1'),"Website Information";print color('bold cyan'),"                                 #   \n";
    print color('bold cyan'),"#                              ";print color('reset'),item('2'),"Domain Whois Lookup";print color('bold cyan'),"                                 #   \n";
    print color('bold cyan'),"#                              ";print color('reset'),item('3'),"Find IP Location";print color('bold cyan'),"                                    #   \n";
    print color('bold cyan'),"#                              ";print color('reset'),item('4'),"Active Port Scanner";print color('bold cyan'),"                                 #   \n";
    print color('bold cyan'),"#                              ";print color('reset'),item('5'),"Subdomain Scanner";print color('bold cyan'),"                                   #   \n";
    print color('bold cyan'),"#                              ";print color('reset'),item('6'),"Reverse IP Lookup";print color('bold cyan'),"                                   #   \n";
    print color('bold cyan'),"#                              ";print color('reset'),item('7'),"Technology lookup";print color('bold cyan'),"                                   #   \n";
    print color('bold cyan'),"#                              ";print color('reset'),item('8'),"Bypass CloudFlare";print color('bold cyan'),"                                   #   \n";
    print color('bold cyan'),"#                              ";print color('reset'),item('9'),"CMS Scanner";print color('bold cyan'),"                                         #   \n";
    print color('bold cyan'),"#                              ";print color('reset'),item('0'),"Exit";print color('bold cyan'),"                                                #   \n",line_d();
    print color('bold green'),"\n\nReconWolf: _>  ";
    print color('reset');

    chomp($number=<STDIN>);

    if($number eq '1'){
        banner();
        print line_u(),color('bold cyan'),"#                              ";print color('reset'),item(),"Enter Traget Website";print color('bold cyan'),"                                #   \n",line_d();
        print color('bold green'),"\n\nReconWolf: _>  ";
        print color('bold white');
        chomp($info=<STDIN>);
        print "\n";
        Websiteinformation();
        enter();
    }if($number eq '2'){
        banner();
        print line_u(),color('bold cyan'),"#                              ";print color('reset'),item(),"Enter Traget Website";print color('bold cyan'),"                                #   \n",line_d();
        print color('bold green'),"\n\nReconWolf: _>  ";
        print color('bold white');
        chomp($whois=<STDIN>);
        print "\n";
        Domainwhoislookup();
        enter();
    }if($number eq '3'){
        banner();
        print line_u(),color('bold cyan'),"#                             ";print color('reset'),item(),"Enter Traget Website/IP";print color('bold cyan'),"                              #   \n",line_d();
        print color('bold green'),"\n\nReconWolf: _>  ";
        print color('bold white');
        chomp($geo=<STDIN>);
        print "\n";
        Findiplocation();
        enter();
    }if($number eq '4'){
        banner();
        port();
        enter();
    }if($number eq '5'){
        banner();
        print line_u(),color('bold cyan'),"#                              ";print color('reset'),item(),"Enter Traget Website";print color('bold cyan'),"                                #   \n",line_d();
        print color('bold green'),"\n\nReconWolf: _>  ";
        print color('bold white');
        chomp($sub=<STDIN>);
        print "\n";
        subdomain();
        enter();
    }if($number eq '6'){
        banner();
        print line_u(),color('bold cyan'),"#                             ";print color('reset'),item(),"Enter Traget Website/IP";print color('bold cyan'),"                              #   \n",line_d();
        print color('bold green'),"\n\nReconWolf: _>  ";
        print color('bold white');
        chomp($rev=<STDIN>);
        print "\n";
        revip();
        enter();
    }if($number eq '7'){
        banner();
        print line_u(),color('bold cyan'),"#                             ";print color('reset'),item(),"Enter Traget Website/IP";print color('bold cyan'),"                              #   \n",line_d();
        print color('bold green'),"\n\nReconWolf: _>  ";
        print color('bold white');
        chomp($tech=<STDIN>);
        print "\n";
        Technology();
        enter();
    }if($number eq '8'){
        banner();
        print line_u(),color('bold cyan'),"#                              ";print color('reset'),item(),"Enter Traget Website";print color('bold cyan'),"                                #   \n",line_d();
        print color('bold green'),"\n\nReconWolf: _>  ";
        print color('bold white');
        chomp($cloud=<STDIN>);
        print "\n";
        CloudFlare();
        enter();
    }if($number eq '9'){
        banner();
        print line_u(),color('bold cyan'),"#                              ";print color('reset'),item(),"Enter Traget Website";print color('bold cyan'),"                                #   \n",line_d();
        print color('bold green'),"\n\nReconWolf: _>  ";
        print color('bold white');
        chomp($cms=<STDIN>);
        print "\n";
        cms();
        enter();
    }
    if($number eq '0'){
        exit;
    }
    else{
        banner();
        menu();
    }
}

#--------------------------------------------------------------#
#                     Website information                      #
#--------------------------------------------------------------#
sub Websiteinformation {
    $url = "https://myip.ms/$info";
    $request = $ua->get($url);
    $response = $request->content;

    if($response =~/> (.*?) visitors per day </)
    {
        print item(),"Hosting Info for Website: $info\n";
        print item(),"Visitors per day: $1 \n";

        if($response =~/> (.*?) visitors per day on (.*?)</){
            print item(),"Visitors per day: $1 \n";
        }
        $ip= (gethostbyname($info))[4];
        my ($a,$b,$c,$d) = unpack('C4',$ip);
        $ip_address ="$a.$b.$c.$d";
        print item(),"IP Address: $ip_address\n";

        if($response =~/IPv6.png'><a href='\/info\/whois6\/(.*?)'>/)
        {
            $ipv6_address=$1;
            print item(),"Linked IPv6 Address: $ipv6_address\n";
        }
        if($response =~/IP Location: <\/td> <td class='vmiddle'><span class='cflag (.*?)'><\/span><a href='\/view\/countries\/(.*?)\/Internet_Usage_Statistics_(.*?).html'>(.*?)<\/a>/)
        {
            $Location=$1;
            print item(),"IP Location: $Location\n";
        }
        if($response =~/IP Reverse DNS (.*?)<\/b><\/div><div class='sval'>(.*?)<\/div>/)
        {
            $host=$2;
            print item(),"IP Reverse DNS (Host): $host\n";
        }
        if($response =~/Hosting Company: <\/td><td valign='middle' class='bold'> <span class='nounderline'><a title='(.*?)'/)
        {
            $ownerName=$1;
            print item(),"Hosting Company: $ownerName\n";
        }
        if($response =~/Hosting Company \/ IP Owner: <\/td><td valign='middle' class='bold'>  <span class='cflag (.*?)'><\/span> <a href='\/view\/web_hosting\/(.*?)'>(.*?)<\/a>/)
        {
            $ownerip=$3;
            print item(),"Hosting Company IP Owner:  $ownerip\n";
        }
        if($response =~/Hosting Company \/ IP Owner: <\/td><td valign='middle' class='bold'> <span class='nounderline'><a title='(.*?)'/)
        {
            $ownerip=$1;
            print item(),"Hosting Company IP Owner:  $ownerip\n";
        }
        if($response =~/IP Range <b>(.*?) - (.*?)<\/b><br>have <b>(.*?)<\/b>/)
        {
            print item(),"Hosting IP Range: $1 - $2 ($3 ip) \n";
        }
        if($response =~/Hosting Address: <\/td><td>(.*?)<\/td><\/tr>/)
        {
            $address=$1;
            print item(),"Hosting Address: $address\n";
        }
        if($response =~/Owner Address: <\/td><td>(.*?)<\/td>/)
        {
            $addressowner=$1;
            print item(),"Owner Address: $addressowner\n";
        }
        if($response =~/Hosting Country: <\/td><td><span class='cflag (.*?)'><\/span><a href='\/view\/countries\/(.*?)\/(.*?)'>(.*?)<\/a>/)
        {
            $HostingCountry=$1;
            print item(),"Hosting Country: $HostingCountry\n";
        }
        if($response =~/Owner Country: <\/td><td><span class='cflag (.*?)'><\/span><a href='\/view\/countries\/(.*?)\/(.*?)'>(.*?)<\/a>/)
        {
            $OwnerCountry=$1;
            print item(),"Owner Country: $OwnerCountry\n";
        }
        if($response =~/Hosting Phone: <\/td><td>(.*?)<\/td><\/tr>/)
        {
            $phone=$1;
            print item(),"Hosting Phone: $phone\n";
        }
        if($response =~/Owner Phone: <\/td><td>(.*?)<\/td><\/tr>/)
        {
            $Ownerphone=$1;
            print item(),"Owner Phone: $Ownerphone\n";
        }
        if($response =~/Hosting Website: <img class='cursor-help noprint left10' border='0' width='12' height='10' src='\/images\/tooltip.gif'><\/td><td><a href='\/(.*?)'>(.*?)<\/a><\/td>/)
        {
            $website=$1;
            print item(),"Hosting Website: $website\n";
        }
        if($response =~/Owner Website: <img class='cursor-help noprint left10' border='0' width='12' height='10' src='\/(.*?)'><\/td><td><a href='\/(.*?)'>(.*?)<\/a>/)
        {
            $Ownerwebsite=$3;
            print item(),"Owner Website: $Ownerwebsite\n";
        }
        if($response =~/CIDR:<\/td><td> (.*?)<\/td><\/tr>/)
        {
            $CIDR=$1;
            print item(),"CIDR: $CIDR\n";
        }
        if($response =~/Owner CIDR: <\/td><td><span class='(.*?)'><a href="\/view\/ip_addresses\/(.*?)">(.*?)<\/a>\/(.*?)<\/span><\/td><\/tr>/)
        {
            print item(),"Owner CIDR: $3/$4\n\n";
        }
        if($response =~/Hosting CIDR: <\/td><td><span class='(.*?)'><a href="\/view\/ip_addresses\/(.*?)">(.*?)<\/a>\/(.*?)<\/span><\/td><\/tr>/)
        {
            print item(),"Hosting CIDR: $3/$4\n\n";
        }
        $url = "https://dns-api.org/NS/$info";
        $request = $ua->get($url);
        $response = $request->content;
    }else {
        print item(),"Something Went Wrong\n\n";
        print item('Note'),"Enter Website Without HTTP/HTTPs\n";
    }
    my %seen;
    while($response =~m/"value": "(.*?)."/g)
    {
        $ns=$1;
        next if $seen{$ns}++;
        print item(),"NS: $ns \n";
    }
}

#--------------------------------------------------------------#
#                     Domain Whois Lookup                      #
#--------------------------------------------------------------#
sub Domainwhoislookup {
    $url = "https://api.hackertarget.com/whois/?q=$whois";
    $request = $ua->get($url);
    $response = $request->content;

 while($response =~m/(.*?)\n/g)
    {
        print item(),"$1 \n";
        sleep(1);
    }
if ($response =~ /error/) {
        print item(),"Something Went Wrong\n\n";
        print item('Note'),"Enter Website Without HTTP/HTTPs\n";
    }
}



#--------------------------------------------------------------#
#                    Find IP Geo Location                      #
#--------------------------------------------------------------#
sub Findiplocation {
    $ip= (gethostbyname($geo))[4];
    my ($a,$b,$c,$d) = unpack('C4',$ip);
    $ip ="$a.$b.$c.$d";

    $url = "https://ipapi.co/$ip/json/";
    $request = $ua->get($url);
    $response = $request->content;

    if($response =~/country_name": "(.*?)"/){
        print item(),"IP Address: $ip\n";
        print item(),"Country: $1\n";
        if($response =~/city": "(.*?)"/){
            print item(),"City: $1\n";
        }if($response =~/region": "(.*?)"/){
            print item(),"Region: $1\n";
        }if($response =~/region_code": "(.*?)"/){
            print item(),"Region Code: $1\n";
        }if($response =~/continent_code": "(.*?)"/){
            print item(),"Continent Code: $1\n";
        }if($response =~/postal": "(.*?)"/){
            print item(),"Postal Code: $1\n";
        }if($response =~/latitude": (.*?),/){
            print item(),"Latitude / Longitude: $1, ";
        }if($response =~/longitude": (.*?),/){
            print color("bold white"),"$1\n";
        }if($response =~/timezone": "(.*?)"/){
            print item(),"Timezone: $1\n";
        }if($response =~/utc_offset": "(.*?)"/){
            print item(),"Utc Offset: $1\n";
        }if($response =~/country_calling_code": "(.*?)"/){
            print item(),"Calling Code: $1\n";
        }if($response =~/currency": "(.*?)"/){
            print item(),"Currency: $1\n";
        }if($response =~/languages": "(.*?)"/){
            print item(),"Languages: $1\n";
        }if($response =~/asn": "(.*?)"/){
            print item(),"ASN: $1\n";
        }if($response =~/org": "(.*?)"/){
            print item(),"ORG: $1\n";
        }
    }else {
        print item(),"Something Went Wrong\n\n";
        print item('Note'),"Enter Website Without HTTP/HTTPs\n";
    }
}

#--------------------------------------------------------------#
#                         Port Scanner                         #
#--------------------------------------------------------------#
sub port {
        print line_u(),color('bold cyan'),"#                             ";print color('reset'),item(),"Enter Traget Website/IP";print color('bold cyan'),"                              #   \n",line_d();
        print color('bold green'),"\n\nReconWolf: _>  ";
        print color('bold white');
        chop ($op = <stdin>);
    $| = 1;

    print "\n";
    print item(),"PORT  STATE   SERVICE\n";
    my %ports = (
        21   => 'FTP'
        ,22   => 'SSH'
        ,23   => 'Telnet'
        ,25   => 'SMTP'
        ,43   => 'Whois'
        ,53   => 'DNS'
        ,68   => 'DHCP'
        ,80   => 'HTTP'
        ,110  => 'POP3'
        ,115  => 'SFTP'
        ,119  => 'NNTP'
        ,123  => 'NTP'
        ,139  => 'NetBIOS'
        ,143  => 'IMAP'
        ,161  => 'SNMP'
        ,220  => 'IMAP3'
        ,389  => 'LDAP'
        ,443  => 'SSL'
        ,1521 => 'Oracle SQL'
        ,2049 => 'NFS'
        ,3306 => 'mySQL'
        ,5800 => 'VNC'
        ,8080 => 'HTTP'
    );
    foreach my $p ( sort {$a<=>$b} keys( %ports ) )
    {
        $socket = IO::Socket::INET->new(PeerAddr => $op , PeerPort => "$p" , Proto => 'tcp' , Timeout => 1);
        if( $socket ){
            print item(); printf("%4s  Open    %s\n", $p, $ports{$p});

        }else{
            print item(); printf("%4s  Closed  %s\n", $p, $ports{$p});
        }
    }
}

#--------------------------------------------------------------#
#                      Subdomain Scanner                       #
#--------------------------------------------------------------#
sub subdomain {
    $url = "https://www.pagesinventory.com/search/?s=$sub";
    $request = $ua->get($url);
    $response = $request->content;

    $ip= (gethostbyname($sub))[4];
    my ($a,$b,$c,$d) = unpack('C4',$ip);
    $ip_address ="$a.$b.$c.$d";
    if($response =~ /Search result for/){
        print item(),"Website: $sub\n";
        print item('+'),"IP: $ip_address\n\n";

        while($response =~ m/<td><a href=\"\/domain\/(.*?).html\">(.*?)<a href="\/ip\/(.*?).html">/g ) {

            print item(),"Subdomain: $1\n";
            print item('+'),"IP: $3\n\n";
            sleep(1);
        }
    }elsif($ip_address =~ /[0-9]/){
        if($response =~ /Nothing was found/){
            print item(),"Website: $sub\n";
            print item(),"IP: $ip_address\n\n";
            print item(),"No Subdomains Found For This Domain\n";
        }}
        else {
        print item(),"Something Went Wrong\n\n";
        print item('Note'),"Enter Website Without HTTP/HTTPs\n";
    }
}

#--------------------------------------------------------------#
#                     Reverse IP Scanner                       #
#--------------------------------------------------------------#
sub revip{
    $url = "https://api.hackertarget.com/reverseiplookup/?q=$rev";
    $request = $ua->get($url);
    $response = $request->content;

 while($response =~m/(.*?)\n/g)
    {
        print item(),"$1 \n";
        print color('reset');
        sleep(1);
    }
    if ($response =~ /error/){
        print item(),"Something Went Wrong\n\n";
        print item('Note'),"Enter Website Without HTTP/HTTPs\n";
    }
}

#--------------------------------------------------------------#
#                      Technology lookup                       #
#--------------------------------------------------------------#
sub Technology {
    $url = "https://api.wappalyzer.com/lookup-basic/beta/?url=http://$tech";
    $request = $ua->get($url);
    $response = $request->content;

    my $responseObject = decode_json($response);
    
    while($response =~m/"name":"(.*?)"/g)
    {
        print item(),"$1 \n";
    }
    if ($response =~ /"message"/){
        print item(),"Something Went Wrong\n\n";
        print item('Note'),"Enter Website Without HTTP/HTTPs\n";
    }
}

#--------------------------------------------------------------#
#                      Bypass CloudFlare                       #
#--------------------------------------------------------------#
sub CloudFlare {
    my $ua = LWP::UserAgent->new;
    $ua = LWP::UserAgent->new(keep_alive => 1);
    $ua->agent("Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.31 (KHTML, like Gecko) Chrome/26.0.1410.63 Safari/537.31");

    $ip= (gethostbyname($cloud))[4];
    my ($a,$b,$c,$d) = unpack('C4',$ip);
    $ip_address ="$a.$b.$c.$d";
    if($ip_address =~ /[0-9]/){
        print item(),"CloudFlare IP: $ip_address\n\n";
    }

    $url = "https://dns-api.org/NS/$cloud";
    $request = $ua->get($url);
    $response = $request->content;

my %seen;
    while($response =~m/"value": "(.*?)."/g)
    {
        $ns=$1;
        next if $seen{$ns}++;
        print item(),"NS: $ns \n";
    }
    print color("bold white"),"\n";
    $url = "http://www.crimeflare.org:82/cgi-bin/cfsearch.cgi";
    $request = POST $url, [cfS => $cloud];
    $response = $ua->request($request);
    $riahi = $response->content;

    if($riahi =~m/">(.*?)<\/a>&nbsp/g){
        print item(),"Real IP: $1\n";
        $ip=$1;
    }elsif($riahi =~m/not CloudFlare-user nameservers/g){
        print item(),"These Are Not CloudFlare-user Nameservers !!\n";
        print item(),"This Website Not Using CloudFlare Protection\n";
    }elsif($riahi =~m/No direct-connect IP address was found for this domain/g){
        print item(),"No Direct Connect IP Address Was Found For This Domain\n";
    }else{
        print item(),"Something Went Wrong\n\n";
        print item('Note'),"Enter Website Without HTTP/HTTPs\n";
    }

    $url = "http://ipinfo.io/$ip/json";
    $request = $ua->get($url);
    $response = $request->content;

    if($response =~m/hostname": "(.*?)"/g){
        print item(),"Hostname: $1\n";
    }if($response =~m/city": "(.*?)"/g){
        print item(),"City: $1\n";
    }if($response =~m/region": "(.*?)"/g){
        print item(),"Region: $1\n";
    }if($response =~m/country": "(.*?)"/g){
        print item(),"Country: $1\n";
    }if($response =~m/loc": "(.*?)"/g){
        print item(),"Location: $1\n";
    }if($response =~m/org": "(.*?)"/g){
        print item(),"Organization: $1\n";
    }
}

#--------------------------------------------------------------#
#                         CMS Scanner                          #
#--------------------------------------------------------------#
sub cms {
    $apicms = "1461fc047b84c0cfee4504b5d7284d84c22c35d6ae8e1d104f14fad59090d608eeab06";
    $url = "https://whatcms.org/APIEndpoint?key=$apicms&url=$cms";
    $request = $ua->get($url);
    $response = $request->content;

    my $responseObject = decode_json($response);

    if($response =~/Success/){
        print item(),"WebSite : $cms \n";
        if (exists $responseObject->{'result'}->{'name'}){
            print item(),'CMS: ',
            $responseObject->{'result'}->{'name'},"\n";}
        if (exists $responseObject->{'result'}->{'version'}){
            print item(),'Version: ',
            $responseObject->{'result'}->{'version'},"\n";}
    }elsif($response =~/CMS Not Found/){
        print item(),"WebSite : $cms \n";
        print item(),"CMS :";
        print color("bold red")," Not Found\n";
        print color('reset');
    }else{
        print item(),"Something Went Wrong\n\n";
        print item('Note'),"Enter Website Without HTTP/HTTPs\n";
    }
}

#--------------------------------------------------------------#
#                            Enter                             #
#--------------------------------------------------------------#
sub enter {
    print "\n";
    print item(),"Press ";
    print color('bold red'),"[";
    print color("bold white"),"ENTER";
    print color('bold red'),"] ";
    print color("bold white"),"To Continue\n";

    local( $| ) = ( 1 );

    my $resp = <STDIN>;
    banner();
    menu();
}

#--------------------------------------------------------------#
#                             Format                           #
#--------------------------------------------------------------#
sub item
{
    my $n = shift // '!';
    return color('bold red')," ["
    , color('bold green'),"$n"
    , color('bold red'),"] "
    , color("bold white")
    ;
}

sub line_u
{
    return 
    color('bold cyan'),"#---------------------------------------------------------------------------------------# \n",
    "#                                                                                       # \n";
    
}

sub line_d
{
    return
    color('bold cyan'),"#                                                                                       # \n",
    "#---------------------------------------------------------------------------------------# \n";
}
#--------------------------------------------------------------#
#                          ~~The End~~                         #
#--------------------------------------------------------------#
