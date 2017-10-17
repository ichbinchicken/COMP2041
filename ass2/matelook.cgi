#!/usr/bin/perl -w

# written by ziming zheng z5052592
# 19/10/16
# URL: cgi.cse.unsw.edu.au/~z5052592/ass2/matelook.cgi

use CGI qw/:all/;
use CGI::Carp qw/fatalsToBrowser warningsToBrowser/;


sub main() {
    # print start of HTML ASAP to assist debugging if there is an error in the script
    print page_header();

    # Now tell CGI::Carp to embed any warning in HTML
    warningsToBrowser(1);

    # define some global variables
    $debug = 1;
    $users_dir = "dataset-medium";
    gatherPosts();
    gatherName();
    gatherPasswords();
    user_page();
    print page_trailer();
}

sub gatherName {
    my @users = sort(glob("$users_dir/*"));
    foreach my $user (@users) {
        open my $f, "$user/user.txt";
        $bufferUser = $user;
        $bufferUser =~ s/$users_dir\///;
        while (<$f>) {
            if ($_ =~ /^full_name/) {
                $_ =~ s/full_name\=//;
                chomp $_;
                $nameData{$bufferUser} = $_;
            }
        }
		close $f;
    }
}

# gather all the posts of users:
sub gatherPosts {
    our %postsData = ();
    my @users = sort(glob("$users_dir/*"));
    foreach my $user (@users) {
        my @posts_filename = sort(glob("$user/posts/*"));
        $user =~ s/[^z0-9]*//;
        #print $user, "\n";
        $postsData{$user} = "";
        @posts = ();
        foreach my $eachPost (@posts_filename) {
            if (open my $p, "$eachPost/post.txt") {
            	while (my $word = <$p>) {
                	if ($word =~ /^message/) {
                	    $word .= "<br>";
                	    push @posts, $word;
                	} elsif ($word =~ /^time/) {
                	    $word =~ s/T/ /;
                	    $word =~ s/\+0000//;
                	    $word .= "<br>";
                	    push @posts, $word;
                	}
            	}
            	$postsData{$user} = join("", @posts);
           		close $p;
			}
        }
    }
}
# gather users's password int hash
sub gatherPasswords {
    my @users = sort(glob("$users_dir/*"));
    foreach my $user (@users) {
        open my $f, "$user/user.txt";
        $bufferUser = $user;
        $bufferUser =~ s/$users_dir\///;
        while (<$f>) {
            if ($_ =~ /^password/) {
                $_ =~ s/password\=//;
                chomp $_;
                $passwordData{$bufferUser} = $_;
            }
        }
		close $f;
    }
}

#
# Show unformatted details for user "n".
# Increment parameter n and store it as a hidden variable
#
sub user_page {
    my $n = param('n') || 0;
    my $searchString = param('searchString');
    my $postString = param('postString');
    my @users = sort(glob("$users_dir/*"));
    my $user_to_show;
    my @fullNameData;
    $loginUsername = param("loginUsername") || "";
    $loginPassword = param("loginPassword") || "";
    $currUser = $users[$n % @users];
    $currN = $n;
    if (($n == 0 || param("next")) && ($n != @users)) {
        $user_to_show  = $users[$n % @users];
    } elsif ($n != 1 && param("back")) {
        $user_to_show  = $users[($n-2) % @users];
    } elsif ($n == 1) {
        $user_to_show  = $users[($n-1) % @users];
    } elsif ($n == @users) {
        $user_to_show  = $users[($n-1) % @users];
    }
    my $details_filename = "$user_to_show/user.txt";
	my $intro_filename = "$user_to_show/intro.txt";
    my @posts_filename = sort(glob("$user_to_show/posts/*"));
    my @postF2 = sort(glob("$user_to_show/posts/*"));
    open my $f, "$details_filename" or die "can not open $details_filename: $!";
    my $userName;
    my $userFriends;
    my $userZid;
    my $userProgram;
    while (my $line = <$f>) {
	    $line =~ s/\=/\: /;
        if ($line =~ /^full_name/) {
            $line =~ s/\_/ /;
 	        $line =~ s/\n/<br><br>/;
            $line = ucfirst($line);
            $userName = $line;
        } elsif ($line =~ /^mates/) {
            $line = ucfirst($line);
            $userFriends = $line;
        } elsif ($line =~ /^zid/) {
	        $line =~ s/\n/<br>/;
            $line = ucfirst($line);
            $userZid = $line;
        } elsif ($line =~ /^program/) {
	        $line =~ s/\n/<br><br>/;
            $line = ucfirst($line);
            $userProgram = $line;
        }
    }
    close $f;
	# display intro:
    if (-e $intro_filename) {
        open my $i, "$intro_filename";
    	while (<$i>) {
    		$_ .= "<br>";
    		push @intro, $_;
    	}
    	$intro = join "", @intro;
    }
    # display posts:
    my @posts;
    my $joinPosts;
    my @joinPosts;
    for($i = @posts_filename-1;$i >=0;$i--) {
        my $posts_filename = "$posts_filename[$i]/post.txt";
        open my $p, "$posts_filename" or die "can not open";
        @posts = ();
        while (my $word = <$p>) {
            if ($word =~ /^message/) {
                $word =~ s/\\n/\n/g;
				$word .= "<br>";
                push @posts, $word;
            } elsif ($word =~ /^time/) {
                $word =~ s/T/ /;
                $word =~ s/\+0000//;
				$word .= "<br>";
                push @posts, $word;
            }
        }
        @posts = sort @posts;
        foreach my $k (@posts) {
            if ($k =~ /^message/) {
                $k .= "<br><br>";
            }
            $k =~ s/^message=/\n/;
            $k =~ s/^time=//;
        }
        $joinPosts = join '', @posts;
        push @joinPosts, $joinPosts;
        close $p;
    }
    # deal with mates lists:
    $userFriends =~ s/Mates:\s*\[//;
    $userFriends =~ s/\]//;
    my @mates = split ',', $userFriends;
    foreach my $m (@mates) {
        $m =~ s/[^z0-9]//g;
    }
    # deal with back and next user:
    my $next_user;
    if ($n == 0) {
        $next_user = $n + 1;
    }
    if (param("next") && $n < @users) {
        $next_user = $n + 1;
    }
    if (param("back") && $n > 1) {
        $next_user = $n - 1;
    }
    if ($n == 1 && param("back")) {
        $next_user = 1;
    }
    if ($n == @users && param("next")) {
        $next_user = @users;
    }

    # flags:
    $usernameCorrect = 0;
    $passwordCorrect = 0;
    # check password:
    if ($loginUsername ne '' && $loginPassword ne "" && !defined param("Login")) {
        chomp $loginPassword;
        chomp $loginUsername;
        $loginPassword = substr($loginPassword, 0, 32);
        $loginUsername = substr($loginUsername, 0, 32);
        $loginPassword =~ s/[;:<>\/ ]//g;
        $loginUsername =~ s/[;:<>\/ ]//g;
        foreach my $zid (keys %nameData) {
            if ($loginUsername eq $zid) {
                $usernameCorrect = 1;
                last;
            }
        }
        foreach my $zid (keys %passwordData) {
            if ($loginPassword eq $passwordData{$zid}) {
                $passwordCorrect = 1;
                last;
            }
        }
        # give feedback of checking password:
        if ($passwordCorrect && $usernameCorrect) {
            print "<h2 class=\"text\">Login Successful! Let's party in matelook!XD</h2><br>";
            print "<form method=\"post\" action=\"\">";
            print "<input type=\"submit\" name=\"Login\" value=\"GO TO HOMEPAGE->\" class=\"matelook_button\">";
            print "</form>";
        } else {
            print "<h2 class=\"text\">Permission Denied :(</h2><br>";
            print "<p class=\"text\">Maybe your password is wrong</p>";
            print "<p class=\"text\">Maybe your username is wrong</p>";
            print "<p class=\"text\">Maybe you are NOT over 18......-->Please contact Australian Federal Police</p>";
            print "<form method=\"post\" action=\"\">";
            print "Username:<br>";
            print "<input type=\"text\" placeholder=\"Enter username\" name=\"loginUsername\"><br>";
            print "Password:<br>";
            print "<input type=\"text\" placeholder=\"Enter Password\" name=\"loginPassword\"><br>";
            print "<input type=\"submit\" name=\"check\" value=\"Login\" class=\"matelook_button\">";
            print "</form>";
        }
    }
    # if login Successfully, you can make posts, edit details, make intro, and search:
    if (defined param('Login')) {
        #search Name:
        if (defined param("searchName")) {
            my @zidSearched = ();
            $currUser = param("zidBuffer");
            $currN = param("nBuffer");
            foreach my $name (%nameData) {
                $name =~ s/Full name: //;
                my $buffer = $name;
                $buffer =~ s/\s*//g;
                if (index(lc($buffer), lc($searchString)) != -1) {
                    print "<p class=\"matelook_user_details\">$name contains $searchString</p>";
                    foreach my $key (keys %nameData) {
                        if ($nameData{$key} eq $name) {
                            push @zidSearched, $key;
                        }
                    }
                }
            }
            my $pos = 0;
            while ($pos < @zidSearched) {
                for ($var = 0; $var < @users; $var++) {
                    $users[$var] =~ s/$users_dir\///;
                    if ($zidSearched[$pos] eq $users[$var]) {
                        last;
                    }
                }
                my $prevID;
                if ($var != 0 && $var < @users) {
                    $prevID = $users[$var - 1];
                } elsif ($var == 0) {
                    $prevID = $users[0];
                } else {
                    print "error\n";
                }
                # It doesn't matter the value of n, as long as get the correct person.
                my $nameSearched;
                open my $n, "$users_dir/$zidSearched[$pos]/user.txt";
                while (<$n>) {
                    if ($_ =~ /^full_name/) {
                        $_ =~ s/full_name=//;
                        $nameSearched = $_;
                        last;
                    }
                }
                print "<a class=\"text\" href=\"matelook.cgi?zid=$prevID&n=$var&next=Next+user&Login=\"1\"><img src=\"$users_dir/$zidSearched[$pos]/profile.jpg\" width=\"100\" height=\"100\"/>$nameSearched</a>";
                $pos++;
            }

            print "<a class=\"text matelook_button\" class href=\"matelook.cgi?zid=$currUser&n=$currN&next=Next+user&Login=\"1\">Return Homepage</a>";
        }
        # search posts:
        if (defined param("searchPosts")) {
            $currUser = param("zidBuffer");
            $currN = param("nBuffer");
            $postString =~ s/[;:<>\/][\s]//g;
            $buff = $postString;
            @p3 = split("", $buff);
            if (@p3 < 2 && @p3 > 0) {
                print "<div class=\"card-panel teal lighten-2 text\"><h3>Search Results</h3></div>";
                print "<div class=\"matelook_user_details\">The word is too short :(</div>";
            } elsif ($postString ne "") {
                @p2 = ();
                foreach my $key (keys %postsData) {
                    @p1 = split('<br>', $postsData{$key});
                    foreach my $p1 (@p1) {
                        if ($p1 =~ /^message=/) {
                            $p1 =~ s/^message=//;
                            if (index(lc($p1), lc($postString)) != -1) {
                                push @p2, $p1;
                            }
                        }
                    }
                }
                print "<div class=\"card-panel teal lighten-2 text\"><h3>Search Results</h3></div>";
                if (@p2 == 0) {
                    print "<br>";
                    print "<div class=\"matelook_user_details\">No Result Try again! :(</div>";
                } else {
                    foreach my $x (@p2) {
                        print "<br>";
                        print "<div class=\"matelook_user_details\">$x<br></div>";
                    }
                }
            } else {
                print "<div class=\"card-panel teal lighten-2 text\"><h3>Search Results</h3></div>";
                print "<div class=\"matelook_user_details\">Empty Search! :(</div>";
            }
            $currUser =~ s/$users_dir\///g;
            print "<a class=\"text matelook_button\" class href=\"matelook.cgi?zid=$currUser&n=$currN&next=Next+user&Login=\"1\">Return Homepage</a>";
        }
        # make posts:
        if(defined param('party')) {
            $createPost = param("createPost");
            $currUser = param('zidBuffer');
            $currN = param('nBuffer');
            if ($createPost ne "") {
                for ( $var = 0; $var < @users; $var++) {
                    if ($users[$var] eq $currUser) {
                        last;
                    }
                }
                if ($var < @users) {
                    @postCount = sort(glob("$users[$var]/posts/*"));
                    $newPost = @postCount;
                    $createPost =~ s/\n/\\n/g;
                    chomp $createPost;
                    $createPost = "message=".$createPost."\n";
                    ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime();
                    $year += 1900;
                    $mon += 1;
                    $createPost .= "time=$year-$mon-$mday $hour:$min:$sec";
                    `mkdir $users[$var]/posts/$newPost`;
                    $postName = "$users[$var]/posts/$newPost/post.txt";
                    if (open FILE, '>', $postName) {
                        print FILE $createPost;
                        close FILE;
                        print "<h2 class=\"text\">File saved</h2><br>";
                    } else {
                        print "<h2 class=\"text\">Not Saved:(</h2><br>";
                    }
                }
            } else {
                print "<h2 class\"text\">Your Post is Empty</h2>";
            }
            $currUser =~ s/$users_dir\///g;
            print "<a class=\"text matelook_button\" class href=\"matelook.cgi?zid=$currUser&n=$currN&next=Next+user&Login=\"1\">Return Homepage</a>";
        }
        # reply somebody and comment:
        if (defined param('reply')) {
            $currUser = param('zidBuffer');
            $currN = param('nBuffer');
            $whichPost = param('whichPost');
            $currUser =~ s/$users_dir\///g;
            $createComment = param("createComment");
            if ($createComment ne "") {
                for ($var = 0; $var < @users; $var++) {
                    $users[$var] =~ s/$users_dir\///;
                    if ($users[$var] eq $currUser) {
                        last;
                    }
                }
                if ($var < @users) {
                    # deal with comments texts:
                    $createComment =~ s/\n/\\n/g;
                    chomp $createComment;
                    $createComment = "message=".$createComment."\n";
                    ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime();
                    $year += 1900;
                    $mon += 1;
                    $createComment .= "time=$year-$mon-$mday $hour:$min:$sec";

                    # determine the comments belongs to which post:
                    @files = sort(glob("$users_dir/$currUser/posts/*"));
                    foreach my $file (@files) {
                        $n = "$file/post.txt";
                        open $u, "$n" or die "can not open";
                        @f = ();
                        while (<$u>) {
                            if ($_ =~ /^message/) {
                                $_ =~ s/\\n/\n/g;
                                push @f, $_;
                            } elsif ($_ =~ /^time/) {
                                $_ =~ s/T/ /;
                                $_ =~ s/\+0000//;
                                push @f, $_;
                            }
                        }
                        @f = sort @f;
                        foreach my $k (@f) {
                            if ($k =~ /^message/) {
                                $k .= "<br><br>";
                            }
                            $k =~ s/^message=/\n/;
                            $k =~ s/^time=//;
                        }
                        $joined = join '', @f;
                        push @joined, $joined;
                        close $u;
                    }
                    for ($v = 0; $v < @joined; $v++) {
                        $joined[$v] =~ s/[^a-zA-Z]//g;
                        $whichPost =~ s/[^a-zA-Z]//g;
                        if ($whichPost eq $joined[$v]) {
                            last;
                        }
                    }
                    if ($v < @joined) {
                        $users[$var] = $users_dir."/".$users[$var];
                        @commPosts = sort(glob("$users[$var]/posts/$v/*"));
                        if (@commPosts == 1) {
                            `mkdir $users[$var]/posts/$v/comments`;
                            `mkdir $users[$var]/posts/$v/comments/0`;
                            $commName = "$users[$var]/posts/$v/comments/0/comment.txt";
                            if (open FILE, '>', $commName) {
                                print FILE $createComment;
                                close FILE;
                                print "<h2 class=\"text\">Reply saved in $commName</h2><br>";
                            } else {
                                print "<h2 class=\"text\">Not Saved:(</h2><br>";
                            }
                        } elsif (@commPosts > 1) {
                            @comms = sort(glob("$users[$var]/posts/$v/comments/*"));
                            $dirNum = @comms;
                            `mkdir $users[$var]/posts/$v/comments/$dirNum`;
                            $commName = "$users[$var]/posts/$v/comments/$dirNum/comment.txt";
                            if (open FILE, '>', $commName) {
                                print FILE $createComment;
                                close FILE;
                                print "<h2 class=\"text\">Reply saved</h2><br>";
                            } else {
                                print "<h2 class=\"text\">Not Saved:(</h2><br>";
                            }
                        } elsif (@commPosts < 1) {
                            print "you wrong!!<br>";
                        }
                    }
                }
            } else {
                print "<h2 class\"text\">Your reply is Empty</h2>";
            }
            print "<a class=\"text matelook_button\" class href=\"matelook.cgi?zid=$currUser&n=$currN&next=Next+user&Login=\"1\">Return Homepage</a>";
        }
        #make intro:
		if (defined param('intro')) {
			$createIntro = param("createIntro");
            $currUser = param('zidBuffer');
            $currN = param('nBuffer');
			$introName = "$currUser/intro.txt";
			if (open FILE, '>', $introName) {
            	print FILE $createIntro;
                close FILE;
                print "<h2 class=\"text\">saved</h2><br>";
            } else {
                print "<h2 class=\"text\">Not Saved:(</h2><br>";
            }
			print "<a class=\"text matelook_button\" class href=\"matelook.cgi?zid=$currUser&n=$currN&next=Next+user&Login=\"1\">Return Homepage</a>";
		}
        # create a new account and reset:
		if (defined param('newAccount') || defined param('reset')) {
			print <<eof;
				<img src="afp.jpeg"  /><img src="nswPolice.jpeg"  /><h4 class=\"text\">This buggy website cannot keep your information confidential.</h4>
				<p class="text">Note: All the red highlighted information is <span class="register">required*</span></p>
			    <form method="post" action="">
       			<span class="register">Create A New Username</span>:
        		<input id="icon_prefix" class="validate" type="text" placeholder="Enter your new Zid" name="newZid">
        		<span class="register">Create A New Password</span>:
        		<input id="icon_prefix" class="validate" type="text" placeholder="Enter Your new Password" name="newPassword">
				<span class="register">Your Full Name</span>:
        		<input id="icon_prefix" class="validate" type="text" placeholder="Enter Full Name" name="newName">
				<span class="register">Your Email</span>:
        		<input id="icon_prefix" class="validate" type="text" placeholder="Enter Your Email" name="newEmail">
				<span class="text">Your Program</span>:
        		<input id="icon_prefix" class="validate" type="text" placeholder="Enter Program" name="newProgram">
				<span class="text">Your Birthday</span>:
        		<input id="icon_prefix" class="validate" type="text" placeholder="Enter Your Birthday" name="newBirthday">
				<span class="text">Your Home Suburb</span>:
        		<input id="icon_prefix" class="validate" type="text" placeholder="Enter Program" name="newSuburb">
				<span class="text">Introduce Yourself</span>:
        		<textarea id="textarea1" name ="newIntro" class="materialize-textarea" placeholder="Introduce Yourself~"></textarea>
                <span class="text">Upload Your Image</span>:<br>
                <input type="file" name="newPic" accept="image/*">
				<input type="submit" name="submitNewAccount" value="Submit Your Information" class="matelook_button">
				<input type="submit" name="reset" value="Reset" class="matelook_button">
				<input type="hidden" name="zidBuffer" value ="$currUser">
            	<input type="hidden" name="nBuffer" value="$currN">
            	<input type="hidden" name="Login" value="1">
            	<input type="hidden" name="loginUsername" value="$loginUsername">
            	<input type="hidden" name="loginPassword" value="$loginPassword">
        		</form>
eof
		}
        # check new accound and give warning and feedback:
		if (defined param('submitNewAccount')) {
			$newZid = param('newZid');
			$newPassword = param('newPassword');
			$newName = param('newName');
			$newEmail = param('newEmail');
			$newProgram = param('newProgram');
			$newBirthday = param('newBirthday');
			$newSuburb = param('newSuburb');
			$newIntro = param('newIntro');
            $newPic = param('newPic');
			if ($newZid eq "") {
				print "<p class=\"register\">FBI WARNING: Your username is EMPTY</P>";
			}
			if ($newPassword eq "") {
				print "<p class=\"register\">FBI WARNING: Your password is EMPTY</P>";
			}
			if ($newName eq "") {
				print "<p class=\"register\">FBI WARNING: Your Full Name is EMPTY</P>";
			}
			if ($newEmail eq "") {
				print "<p class=\"register\">FBI WARNING: Your Email is EMPTY</P>";
			}
			if ($newZid ne "" && $newPassword ne "" && $newName ne "" && $newEmail ne "") {
				`mkdir $users_dir/$newZid`;
                `mkdir $users_dir/$newZid/posts`;
				if (open F, '>', "$users_dir/$newZid/user.txt") {
					print F "zid=$newZid\nfull_name=$newName\npassword=$newPassword\nemail=$newEmail\nprogram=$newProgram\nbirthday=$newBirthday\nhome_suburb=$newSuburb\n";
					close F;
                    if ($newPic eq "") {
                        `cp minions.jpg $users_dir/$newZid/profile.jpg`;
                        `chmod 755 $users_dir/$newZid/profile.jpg`;
                    } else {
                        #don't know how to write Java Script to save image uploaded.
                    }
					print "<h2 class=\"text\">your information saved</h2><br>";
				} else {
					print "<h2 class=\"text\">your information NOT saved :(</h2><br>";
				}
			}
            if ($newIntro ne "") {
                if (open F, '>', "$users_dir/$newZid/intro.txt") {
                    print F "$newIntro";
                    close F;
                }
            }
			if ($newZid eq "" || $newPassword eq ""|| $newEmail eq ""|| $newName eq "") {
				print <<eof;
					<form method="post" action="">
					<input type="submit" name="reset" value="Reset" class="matelook_button">
					<input type="hidden" name="zidBuffer" value ="$currUser">
            		<input type="hidden" name="nBuffer" value="$currN">
            		<input type="hidden" name="Login" value="1">
            		<input type="hidden" name="loginUsername" value="$loginUsername">
            		<input type="hidden" name="loginPassword" value="$loginPassword">
					</form>
eof
			}
            print "<a class=\"matelook_button\" href=\"matelook.cgi?zid=$currUser&n=$currN&next=Next+user&Login=\"1\">Return Homepage</a>";
		}
        # edit personal details:
        if (defined param('editDetails')) {
            $editName = param('editName');
            $editProgram = param('editProgram');
            $currUser = param('zidBuffer');
            $currN = param('nBuffer');
            open $e, "$currUser/user.txt";
            while (<$e>) {
                if ($_ =~ /^full_name=/) {
                    if ($editName eq "") {
                        print "<h4 class=\"register\">warning: Your new name is empty</h4>";
                    } else {
                        $_ =~ s/.*/full_name=$editName/;
                        $_ .= "\n";
                    }
                    push @usertxt, $_ ;
                } elsif ($_ =~ /^program/) {
                    if ($editName eq "") {
                        print "<h4 class=\"register\">warning: Your new program is empty</h4>";
                    } else {
                        $_ =~ s/.*/program=$editProgram/;
                        $_ .= "\n";
                    }
                    push @usertxt, $_;
                } else {
                    push @usertxt, $_;
                }
            }
            close($e);
            $usertxt = join "", @usertxt;
            if (open F, '>', "$currUser/user.txt") {
                print F $usertxt;
                close F;
                if ($editName ne "" && $editProgram ne "") {
                    print "<h4 class=\"text\">Details Saved</h4>";
                }
            }
            print "<a class=\"matelook_button\" href=\"matelook.cgi?zid=$currUser&n=$currN&next=Next+user&Login=\"1\">Return Homepage</a>";
        }
        # only can delete the most recent:
        if (defined param('deletePost')) {
            $currUser = param('zidBuffer');
            $currN = param('nBuffer');
            @ps = sort(glob("$currUser/posts/*"));
            $dp = $#ps;
            `rm $currUser/posts/$dp/post.txt`;
            `rmdir $currUser/posts/$dp`;
            print "<h3 class=\"register\">post deleted</h3>";
            print "<a class=\"matelook_button\" href=\"matelook.cgi?zid=$currUser&n=$currN&next=Next+user&Login=\"1\">Return Homepage</a>";
        }
        #display host page and host information, one user by one user:
    if (!defined param("searchName") && !defined param("searchPosts") && !defined param('party')
		&& !defined param('reply') && !defined param('intro') && !defined param('newAccount')
        && !defined param('submitNewAccount') && !defined param('reset') && !defined param('editDetails')
        && !defined param('deletePost')) {
		print <<eof;
		<img src="if.png"  />
eof
		print <<eof;
			<form method="post" action="">
			<input type="hidden" name="zidBuffer" value ="$currUser">
            <input type="hidden" name="nBuffer" value="$currN">
            <input type="hidden" name="Login" value="1">
            <input type="hidden" name="loginUsername" value="$loginUsername">
            <input type="hidden" name="loginPassword" value="$loginPassword">
            <input type="submit" name="newAccount" value="Create A New Account~" class="matelook_button">
            </form>
eof
        print <<eof;
            <table class="table" border="0" align="center" width="100%">
            <tr>
            <td>
            <form method="post" action="">
            <input id="icon_prefix" type="text" class="validate" type="text" placeholder="Search Full Name" name="searchString">
            <input type="submit" name="searchName" value="Search" class="matelook_button">
            <input type="hidden" name="zidBuffer" value ="$currUser">
            <input type="hidden" name="nBuffer" value="$currN">
            <input type="hidden" name="Login" value="1">
            <input type="hidden" name="loginUsername" value="$loginUsername">
            <input type="hidden" name="loginPassword" value="$loginPassword">
            </form>
            <form method="post" action="">
            <input id="icon_prefix" class="validate" type="text" placeholder="Search Posts" name="postString">
            <input type="submit" name="searchPosts" value="Search" class="matelook_button">
            <input type="hidden" name="zidBuffer" value ="$currUser">
            <input type="hidden" name="nBuffer" value="$currN">
            <input type="hidden" name="Login" value="1">
            <input type="hidden" name="loginUsername" value="$loginUsername">
            <input type="hidden" name="loginPassword" value="$loginPassword">
            </form>
            <br>
            <div class="matelook_user_details">
            $userName$userProgram$userZid
            </div>
            <p class="matelook_heading">Edit Your Personal Details</p>
            <form method="post" action="">
            <input type="text" name="editName" placeholder="Edit Your Full Name">
            <input type="text" name="editProgram" placeholder="Edit Your Program">
            <input type="hidden" name="zidBuffer" value ="$currUser">
            <input type="hidden" name="nBuffer" value="$currN">
            <input type="hidden" name="Login" value="1">
            <input type="hidden" name="loginUsername" value="$loginUsername">
            <input type="hidden" name="loginPassword" value="$loginPassword">
            <input type="submit" name="editDetails" value="Edit" class="matelook_button">
            </form>
            </td>
            <td>
eof
			if ( -e "$user_to_show/profile.jpg") {
				print <<eof;
            		<img src="$user_to_show/profile.jpg" width="200" height="200" />
eof
			} else {
				print <<eof;
            		<img src="minions.jpg" width="200" height="200" />
eof
			}
			print <<eof;
            <form method="post" action="">
            <input type="submit" name="Logout" value="Logout" class="matelook_button">
            </form>
			<form method="post" action="">
			<textarea id="textarea1" name ="createIntro" class="materialize-textarea" placeholder="Make Intro here!"></textarea>
			<input type="submit" name="intro" value="Create~" class="matelook_button">
			<input type="hidden" name="zidBuffer" value ="$currUser">
            <input type="hidden" name="nBuffer" value="$currN">
            <input type="hidden" name="Login" value="1">
            <input type="hidden" name="loginUsername" value="$loginUsername">
            <input type="hidden" name="loginPassword" value="$loginPassword">
            </form>
eof
			print <<eof if -e $intro_filename;
			<p class="matelook_heading">Look At My Intro!!!</p>
			<br>
			<div class="intro">
            $intro
            </div>
eof
			print <<eof;
            </td>
            </tr>
            <tr>
eof
        print "<td><p class=\"matelook_heading\">Posts</p>";
        print "<form method=\"POST\" action=\"\">";
        print "<div class=\"row\">";
        print "<div class=\"input-field col s12\">";
        print "<textarea id=\"textarea1\" name =\"createPost\" class=\"materialize-textarea\" placeholder=\"Make post here!\"></textarea>";
        print "</div>";
        print "</div>";
        print "<input type=\"hidden\" name=\"zidBuffer\" value =\"$currUser\">";
        print "\<input type=\"hidden\" name=\"nBuffer\" value=\"$currN\">";
        print "<input type=\"hidden\" name=\"Login\" value=\"1\">";
        print "<input type=\"submit\" name=\"party\" value=\"Party~\" class=\"matelook_button\">";
        print "</form><br>";
        my $counter = @joinPosts-1;
        foreach my $post (@joinPosts) {
            $postBuffer = $post;
            $postBuffer =~ s/[0-9]{4}\-[0-9]{2}\-[0-9]{2}.*//;
            $postBuffer =~ s/[^z0-9]+//g;
            $prePost = $post;
            if ($postBuffer =~ /z[0-9]{7}/) {
                for ($pos = 0; $pos < @users; $pos++) {
                    $users[$pos] =~ s/$users_dir\///;
                    if ($users[$pos] eq $postBuffer) {
                        last;
                    }
                }
                if ($pos < @users) {
                    my $prevID = $users[$pos - 1];
                    $prevID =~ s/$users_dir\///;
                    $post =~ s/[z0-9]{8}/<a class=\"text\" href=\"matelook.cgi?zid=$prevID&n=$pos&next=Next+user&Login=\"1\">\@$postBuffer<\/a>/;
                }
            }
            print "<div class=\"matelook_user_details\">$post</div>";
            print <<eof;
                <br>
                <form method="post" action="">
                <input type="hidden" name="zidBuffer" value ="$currUser">
                <input type="hidden" name="nBuffer" value="$currN">
                <input type="hidden" name="Login" value="1">
                <input type="hidden" name="loginUsername" value="$loginUsername">
                <input type="hidden" name="loginPassword" value="$loginPassword">
                <input type="submit" name="deletePost" value="Delete Post~" class="matelook_button">
                </form>
eof
            print "<form method=\"POST\" action=\"\">";
            print "<div class=\"row\">";
            print "<div class=\"input-field col s12\">";
            print "<textarea id=\"textarea1\" name =\"createComment\" class=\"materialize-textarea\" placeholder=\"Make Reply here!\"></textarea>";
            print "</div>";
            print "</div>";
            print "<input type=\"hidden\" name=\"zidBuffer\" value =\"$currUser\">";
            print "<input type=\"hidden\" name=\"nBuffer\" value=\"$currN\">";
            print "<input type=\"hidden\" name=\"Login\" value=\"1\">";
            print "<input type=\"hidden\" name=\"whichPost\" value=\"$prePost\">";
            print "<input type=\"submit\" name=\"reply\" value=\"Reply~\" class=\"matelook_button\">";
            print "</form><br>";
            @commentsPosts = sort(glob("$postF2[$counter]/*"));
            #$l = @commentsPosts;
            if (@commentsPosts > 1) {
                @commentFiles = sort(glob("$postF2[$counter]/comments/*"));
                foreach my $commentFile (@commentFiles) {
                    @finalComments =();
                    open $c, "$commentFile/comment.txt" or die;
                    while (<$c>) {
                        $_ =~ s/\n/<br>/;
                        push @finalComments, $_;
                    }
                    close $c;
                    @finalComments = sort(@finalComments);
                    foreach my $x (@finalComments) {
                        if ($x =~ /^time=/) {
                            $x =~ s/T/ /;
                            $x =~ s/^time=//;
                            $x =~ s/\+0000//;
                        }
                        $x =~ s/^from=/Reply: /;
                        $x =~ s/^message=//;
                    }
                    $joinComments = join "", @finalComments;
                    $commentBuffer = $joinComments;
                    $commentBuffer =~ s/[0-9]{4}\-[0-9]{2}\-[0-9]{2}.*//;
                    $commentBuffer =~ s/[^z0-9]+//g;
                    if ($commentBuffer =~ /z[0-9]{7}/) {
                        $commentBuffer =~ s/z/ z/g;
                        @commentBuffer = split " ", $commentBuffer;
                        for ($pos = 0; $pos < @users; $pos++) {
                            $users[$pos] =~ s/$users_dir\///;
                            for ($pos2 = 0; $pos2 < @commentBuffer; $pos2++) {
                                $flag = 0;
                                if ($users[$pos] eq $commentBuffer[$pos2]) {
                                    $flag = 1;
                                    last;
                                }
                            }
                            if ($flag) {
                                my $link = $commentBuffer[$pos2];
                                my $prevID = $users[$pos - 1];
                                $prevID =~ s/$users_dir\///;
                                $joinComments =~ s/$link/<a class=\"text\" href=\"matelook.cgi?zid=$prevID&n=$pos&next=Next+user&Login=\"1\">\@$link<\/a>/;
                            }
                        }
                    }
                    print "<p class=\"comments\">$joinComments</p>";
                }
            }
            $counter --;
        }
        print "</td>\n";
        print "<td><p class=\"matelook_heading\">Mates</p>";
        my $pos = 0;
        while ($pos < @mates) {
            for ($var = 0; $var < @users; $var++) {
                $users[$var] =~ s/$users_dir\///;
                if ($mates[$pos] eq $users[$var]) {
                    last;
                }
            }
            my $prevID;
            if ($var != 0 && $var < @users) {
                $prevID = $users[$var - 1];
            } elsif ($var == 0) {
                $prevID = $users[0];
            } else {
                print "error\n";
            }
            # It doesn't matter the value of n, as long as get the correct person.
            my $matesName;
            open my $n, "$users_dir/$mates[$pos]/user.txt";
            while (<$n>) {
                if ($_ =~ /^full_name/) {
                    $_ =~ s/full_name=//;
                    $matesName = $_;
                    last;
                }
            }
			if ( -e "$users_dir/$mates[$pos]/profile.jpg") {
				print "<a class=\"text\" href=\"matelook.cgi?zid=$prevID&n=$var&next=Next+user&Login=\"1\"><img src=\"$users_dir/$mates[$pos]/profile.jpg\" width=\"100\" height=\"100\"/>$matesName</a>";
			} else {
				print "<a class=\"text\" href=\"matelook.cgi?zid=$prevID&n=$var&next=Next+user&Login=\"1\"><img src=\"minions.jpg\" width=\"100\" height=\"100\"/>$matesName</a>";
			}
			while (<$n>) {
				if ($_ =~ /^mates=/) {
					$_ =~ s/mates=\[//;
					$_ =~ s/\]//;
					@newMates = split ',', $_;
					last;
				}
			}
    		foreach my $s (@newMates) {
        		$s =~ s/[^z0-9]//g;
				$u = $user_to_show;
				$u =~ s/[^z0-9]//;
				if ($s ne $u) {
					foreach my $m (@mates) {
						$m =~ s/[^z0-9]//;
						if ($m eq $s) {
							push @excluded, $m;
						}
					}
				}
    		}
			foreach my $s (@newMates) {
				$exFlag = 0;
				foreach my $k (@excluded) {
					if ($k eq $s) {
						$exFlag = 1;
						last;
					}
				}
				if (!$exFlag) {
					$suggestions{$s}++;
				}
			}
            $pos++;
        }
		print "<p class=\"matelook_heading\">People You May Know...</p>";
		foreach my $key (keys %suggestions) {
            for ($var = 0; $var < @users; $var++) {
                $users[$var] =~ s/$users_dir\///;
                if ($key eq $users[$var]) {
                    last;
                }
            }
           	my $prevID;
            if ($var != 0 && $var < @users) {
                $prevID = $users[$var - 1];
            } elsif ($var == 0) {
                $prevID = $users[0];
            } else {
                print "error\n";
            }
           	 #It doesn't matter the value of n, as long as get the correct person.
            my $matesName;
            open my $n, "$users_dir/$key/user.txt";
            while (<$n>) {
                if ($_ =~ /^full_name/) {
                    $_ =~ s/full_name=//;
                    $matesName = $_;
                    last;
                }
            }
			close $n;
			if ( -e "$users_dir/$key/profile.jpg") {
				print "<a class=\"text\" href=\"matelook.cgi?zid=$prevID&n=$var&next=Next+user&Login=\"1\"><img src=\"$users_dir/$key/profile.jpg\" width=\"100\" height=\"100\"/>$matesName</a>";
			} else {
				print "<a class=\"text\" href=\"matelook.cgi?zid=$prevID&n=$var&next=Next+user&Login=\"1\"><img src=\"minions.jpg\" width=\"100\" height=\"100\"/>$matesName</a>";
			}
		}
        print "</td></tr></table>";
        $user_to_show =~ s/$users_dir\///;
        print <<eof;
            <p>
            <form method="get" action="">
            <input type="hidden" name="zid" value="$user_to_show">
            <input type="hidden" name="n" value="$next_user">
            <input type="hidden" name="Login" value="1">
            <input type="submit" name="back" value="Back" class="waves-effect waves-light btn">
            <input type="submit" name="next" value="Next user" class="waves-effect waves-light btn">
            <input type="hidden" name="loginUsername" value="$loginUsername">
            <input type="hidden" name="loginPassword" value="$loginPassword">
            </form>
            </p>
eof
    }
    # check login password and give feedback:
} elsif ($loginUsername eq '' && $loginPassword ne '') {
        print "<form method=\"post\" action=\"\">";
        print "Please Enter Your Username:<br>";
        print "<input id=\"icon_prefix\" class=\"validate\" type=\"text\" name=\"loginUsername\"><br>";
        print "<input type=\"hidden\" name=\"loginPassword\" value=\"$loginPassword\"><br>";
        print "<input type=\"submit\" name=\"wrong1\" value=\"Login\" class=\"matelook_button\">";
        print "</form>";
    } elsif ($loginUsername ne '' && $loginPassword eq '') {
        print "<form method=\"post\" action=\"\">";
        print "<input type=\"hidden\" name=\"loginUsername\" value=\"$loginUsername\"><br>";
        print "Please Enter Your Password:<br>";
        print "<input id=\"icon_prefix\" class=\"validate\" type=\"password\" name=\"loginPassword\"><br>";
        print "<input type=\"submit\" name=\"wrong2\" value=\"Login\" class=\"matelook_button\">";
        print "</form>";
    } elsif ($loginUsername eq '' && $loginPassword eq ''){
		print "<img src=\"afp.jpeg\"  /><img src=\"nswPolice.jpeg\"  /><img src=\"single.jpg\"  /><img src=\"lady.jpg\" width=\"325\" height=\"275\"  /><h3 class=\"register\">WARNING:</h3><h4 class=\"register\">This website cannot keep your information confidential</h4>";
        print "<form method=\"post\" action=\"\">";
        print "Username:<br>";
        print "<input id=\"icon_prefix\" class=\"validate\" type=\"text\" placeholder=\"Enter username\" name=\"loginUsername\"><br>";
        print "Password:<br>";
        print "<input id=\"icon_prefix\" class=\"validate\" type=\"password\" placeholder=\"Enter Password\" name=\"loginPassword\"><br>";
        print "<input type=\"submit\" name=\"check\" value=\"Login\" class=\"matelook_button\">";
        print "</form>";
    }
}


#
# HTML placed at the top of every page
#
sub page_header {
    return <<eof
Content-Type: text/html;charset=utf-8

<!DOCTYPE html>
<html lang="en">
<head>
<title>matelook</title>
<style type="text/css">
.table {
    table-layout: fixed;
}
.text {
    font-family: Comic Sans MS;
}
.register {
    font-family: Comic Sans MS;
	color: red;
}
.comments {
    display:block;
    border:thin solid #204142;
    border-radius: 0.5em;
    margin-right: 20px;
    margin-left: 20px;
    font-family: Comic Sans MS;
    background-color: #FFA500;
    color: #204142;
    #white-space: pre;
    padding-top: 0.5em;
    padding-bottom: 0.4em;
    padding-left: 0.5em;
}
.intro {
    display:block;
    border:thin solid #204142;
    border-radius: 0.5em;
    margin-right: 20px;
    margin-left: 20px;
    font-family: Comic Sans MS;
    background-color: #00FF00;
    color: #204142;
    #white-space: pre;
    padding-top: 0.5em;
    padding-bottom: 0.4em;
    padding-left: 0.5em;
}
.matelook_heading {
    color: red;
    padding-top: 1em;
    padding-bottom: 1em;
    text-align: center;
    font-size: x-large;
    font-weight: bold;
    text-decoration: underline;
}
.matelook_user_details {
    display:block;
    border:thin solid #204142;
    border-radius: 0.5em;
    margin-right: 20px;
    margin-left: 20px;
    font-family: Comic Sans MS;
    background-color: #ABCDEF;
    color: #204142;
    #white-space: pre;
    padding-top: 0.5em;
    padding-bottom: 0.4em;
    padding-left: 0.5em;
}
.matelook_button {
    display:block;
    background-color: #FEDBCA;
    border:thin solid #904142;
    border-radius: 0.42em;
    color: #904142;
    margin-right: 11px;
    margin-left: 11px;
    padding-top: 0.5em;
    padding-bottom: 0.4em;
    padding-left: 0.5em;
}
</style>
<link href="matelook.css" rel="stylesheet">
<link type="text/css" rel="stylesheet" href="materialize.min.css"/>
</head>
<body>
<div class="matelook_heading">
matelook
</div>
eof
}

#<body background="back.jpg">
#
# HTML placed at the bottom of every page
# It includes all supplied parameter values as a HTML comment
# if global variable $debug is set
#
sub page_trailer {
    my $html = "";
    $html .= join("", map("<!-- $_=".param($_)." -->\n", param())) if $debug;
    $html .= end_html;
    return $html;
}

main();
