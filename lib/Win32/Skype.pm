package Win32::Skype;

use 5.010000;
use strict;
use warnings;

use Carp;
use Win32::OLE;
use Switch;

our @ISA = qw();

our $VERSION = '0.01';

# Preloaded methods go here.

our $ole;
our $call;

sub new {

    my $self = shift;
    my $class = ref($self) || $self;
    
    return bless {}, $class;
    
}

sub attach {

    my $self = shift;
    
    carp "called without a reference" if ( ! ref($self) );
    
    $ole = Win32::OLE->new('Skype4COM.Skype') or die "Couldn't create an OLE 'Skype4COM.Skype' object.\n";
    
}

sub call {

    my $self = shift;
    
    carp "called without a reference" if ( ! ref($self) );
    
    my $command = '$call = $ole->PlaceCall(';
    
    foreach ( @_ ) {
    
        $command .= "'$_',";
        
    }
    
    eval "$command)";
    
}

sub answer {

    my $self = shift;
    
    carp "called without a reference" if ( ! ref($self) );
    
    $call->Answer;
    
}

sub holdCall {

    my $self = shift;
    
    carp "called without a reference" if ( ! ref($self) );
    
    $call->Hold;
    
}

sub resumeCall {

    my $self = shift;
    
    carp "called without a reference" if ( ! ref($self) );
    
    $call->Resume;
    
}

sub endCall {

    my $self = shift;
    
    carp "called without a reference" if ( ! ref($self) );
    
    my $command = '$call->Finish(';
    
    foreach ( @_ ) {
    
        $command .= "'$_',";
        
    }
    
    eval "$command)";
    
    #$call->Finish;
    
}


sub startVideoSend {

    my $self = shift;
    
    carp "called without a reference" if ( ! ref($self) );
    
    $call->StartVideoSend;
    
}

sub stopVideoSend {

    my $self = shift;
    
    carp "called without a reference" if ( ! ref($self) );
    
    $call->StopVideoSend;
    
}

sub startVideoReceive {

    my $self = shift;
    
    carp "called without a reference" if ( ! ref($self) );
    
    $call->StartVideoReceive;
    
}

sub stopVideoReceive {

    my $self = shift;
    
    carp "called without a reference" if ( ! ref($self) );
    
    $call->StopVideoReceive;
    
}

sub userStatus {

    my $self = shift;
    my $user = shift || $ole->CurrentUser->Fullname;
    
    carp "called without a reference" if ( ! ref($self) );
    
    return $ole->Convert->OnlineStatusToText($ole->User($user)->OnlineStatus);
    
}

sub callStatus {

    my $self = shift;
    
    carp "called without a reference" if ( ! ref($self) );
    
    return $ole->Convert->CallStatusToText($call->Status);
    
}

sub dtmf {

    my $self = shift;
    my $dtmf = shift || '';
    
    carp "called without a reference" if ( ! ref($self) );
    
    if ( $call->Status == $ole->Convert->TextToCallStatus('INPROGRESS') ) {
    
        for ( split //, $dtmf ) {
        
            switch ( $_ ) {
            
                case /[A-Ca-c]/ { $call->{DTMF} = 2; }
                case /[D-Fd-f]/ { $call->{DTMF} = 3; }
                case /[G-Ig-i]/ { $call->{DTMF} = 4; }
                case /[J-Lj-l]/ { $call->{DTMF} = 5; }
                case /[M-Om-o]/ { $call->{DTMF} = 6; }
                case /[P-Sp-s]/ { $call->{DTMF} = 7; }
                case /[T-Vt-v]/ { $call->{DTMF} = 8; }
                case /[W-Zw-z]/ { $call->{DTMF} = 9; }
                else            { $call->{DTMF} = $_; }
                
            }
            
        }
        
    }
    
}

sub userGetHandle {

    my $self = shift;
    
    carp "called without a reference" if ( ! ref($self) );
    
    if ( my $user = shift ) {
    
        return $ole->User($user)->Handle;
        
    } else {
    
        return $ole->CurrentUser->Handle;
        
    }
    
}

sub userGetFullName {

    my $self = shift;
    
    carp "called without a reference" if ( ! ref($self) );
    
    if ( my $user = shift ) {
    
        return $ole->User($user)->FullName;
        
    } else {
    
        return $ole->CurrentUserProfile->FullName;
        
    }
    
}

sub userSetFullName {

    my $self = shift;
    
    carp "called without a reference" if ( ! ref($self) );
    
    return $ole->CurrentUserProfile->{FullName} = shift;
        
}

sub userGetBirthday {

    my $self = shift;
    
    carp "called without a reference" if ( ! ref($self) );
    
    if ( my $user = shift ) {
    
        return $ole->User($user)->Birthday;
        
    } else {
    
        return $ole->CurrentUserProfile->Birthday;
        
    }
    
}

sub userSetBirthday {

    my $self = shift;
    
    carp "called without a reference" if ( ! ref($self) );
    
    return $ole->CurrentUserProfile->{Birthday} = shift;
        
}

sub userGetSex {

    my $self = shift;
    
    carp "called without a reference" if ( ! ref($self) );
    
    if ( my $user = shift ) {
    
        return $ole->Convert->UserSexToText($ole->User($user)->Sex);
        
    } else {
    
        return $ole->Convert->UserSexToText($ole->CurrentUserProfile->Sex);
        
    }
    
}

sub userSetSex {

    my $self = shift;
    
    carp "called without a reference" if ( ! ref($self) );
    
    return $ole->Convert->UserSexToText($ole->CurrentUserProfile->{Sex} = $ole->Convert->TextToUserSex(shift));
        
}

sub userGetLanguage {

    my $self = shift;
    
    carp "called without a reference" if ( ! ref($self) );
    
    if ( my $user = shift ) {
    
        return $ole->User($user)->Language;
        
    } else {
    
        return $ole->CurrentUserProfile->Languages;
        
    }
    
}

sub userSetLanguage {

    my $self = shift;
    
    carp "called without a reference" if ( ! ref($self) );
    
    return $ole->CurrentUserProfile->{Languages} = shift;
        
}

sub userGetCountry {

    my $self = shift;
    
    carp "called without a reference" if ( ! ref($self) );
    
    if ( my $user = shift ) {
    
        return $ole->User($user)->Country;
        
    } else {
    
        return $ole->CurrentUserProfile->Country;
        
    }
    
}

sub userSetCountry {

    my $self = shift;
    
    carp "called without a reference" if ( ! ref($self) );
    
    return $ole->CurrentUserProfile->{Country} = shift;
        
}

sub userGetProvince {

    my $self = shift;
    
    carp "called without a reference" if ( ! ref($self) );
    
    if ( my $user = shift ) {
    
        return $ole->User($user)->Province;
        
    } else {
    
        return $ole->CurrentUserProfile->Province;
        
    }
    
}

sub userSetProvince {

    my $self = shift;
    
    carp "called without a reference" if ( ! ref($self) );
    
    return $ole->CurrentUserProfile->{Province} = shift;
        
}

sub userGetCity {

    my $self = shift;
    
    carp "called without a reference" if ( ! ref($self) );
    
    if ( my $user = shift ) {
    
        return $ole->User($user)->City;
        
    } else {
    
        return $ole->CurrentUserProfile->City;
        
    }
    
}

sub userSetCity {

    my $self = shift;
    
    carp "called without a reference" if ( ! ref($self) );
    
    return $ole->CurrentUserProfile->{City} = shift;
        
}

sub userGetPhoneHome {

    my $self = shift;
    
    carp "called without a reference" if ( ! ref($self) );
    
    if ( my $user = shift ) {
    
        return $ole->User($user)->PhoneHome;
        
    } else {
    
        return $ole->CurrentUserProfile->PhoneHome;
        
    }
    
}

sub userSetPhoneHome {

    my $self = shift;
    
    carp "called without a reference" if ( ! ref($self) );
    
    return $ole->CurrentUserProfile->{PhoneHome} = shift;
        
}

sub userGetPhoneOffice {

    my $self = shift;
    
    carp "called without a reference" if ( ! ref($self) );
    
    if ( my $user = shift ) {
    
        return $ole->User($user)->PhoneOffice;
        
    } else {
    
        return $ole->CurrentUserProfile->PhoneOffice;
        
    }
    
}

sub userSetPhoneOffice {

    my $self = shift;
    
    carp "called without a reference" if ( ! ref($self) );
    
    return $ole->CurrentUserProfile->{PhoneOffice} = shift;
        
}

sub userGetPhoneMobile {

    my $self = shift;
    
    carp "called without a reference" if ( ! ref($self) );
    
    if ( my $user = shift ) {
    
        return $ole->User($user)->PhoneMobile;
        
    } else {
    
        return $ole->CurrentUserProfile->PhoneMobile;
        
    }
    
}

sub userSetPhoneMobile {

    my $self = shift;
    
    carp "called without a reference" if ( ! ref($self) );
    
    return $ole->CurrentUserProfile->{PhoneMobile} = shift;
        
}

sub userGetHomepage {

    my $self = shift;
    
    carp "called without a reference" if ( ! ref($self) );
    
    if ( my $user = shift ) {
    
        return $ole->User($user)->Homepage;
        
    } else {
    
        return $ole->CurrentUserProfile->Homepage;
        
    }
    
}

sub userSetHomepage {

    my $self = shift;
    
    carp "called without a reference" if ( ! ref($self) );
    
    return $ole->CurrentUserProfile->{Homepage} = shift;
        
}

sub userGetAbout {

    my $self = shift;
    
    carp "called without a reference" if ( ! ref($self) );
    
    if ( my $user = shift ) {
    
        return $ole->User($user)->About;
        
    } else {
    
        return $ole->CurrentUserProfile->About;
        
    }
    
}

sub userSetAbout {

    my $self = shift;
    
    carp "called without a reference" if ( ! ref($self) );
    
    return $ole->CurrentUserProfile->{About} = shift;
        
}

sub userGetMood {

    my $self = shift;
    
    carp "called without a reference" if ( ! ref($self) );
    
    if ( my $user = shift ) {
    
        return $ole->User($user)->MoodText;
        
    } else {
    
        return $ole->CurrentUserProfile->MoodText;
        
    }
    
}

sub userSetMood {

    my $self = shift;
    
    carp "called without a reference" if ( ! ref($self) );
    
    return $ole->CurrentUserProfile->{MoodText} = shift;
        
}

sub userGetRichMood {

    my $self = shift;
    
    carp "called without a reference" if ( ! ref($self) );
    
    if ( my $user = shift ) {
    
        return $ole->User($user)->RichMoodText;
        
    } else {
    
        return $ole->CurrentUserProfile->RichMoodText;
        
    }
    
}

sub userSetRichMood {

    my $self = shift;
    
    carp "called without a reference" if ( ! ref($self) );
    
    return $ole->CurrentUserProfile->{RichMoodText} = shift;
        
}

sub userGetTimezone {

    my $self = shift;
    
    carp "called without a reference" if ( ! ref($self) );
    
    if ( my $user = shift ) {
    
        return $ole->User($user)->Timezone;
        
    } else {
    
        return $ole->CurrentUserProfile->Timezone;
        
    }
    
}

sub userSetTimezone {

    my $self = shift;
    
    carp "called without a reference" if ( ! ref($self) );
    
    return $ole->CurrentUserProfile->{Timezone} = shift;
        
}

sub userGetCallNoAnswerTimeout {

    my $self = shift;
    
    carp "called without a reference" if ( ! ref($self) );
    
    return $ole->CurrentUserProfile->CallNoAnswerTimeout;
    
}

sub userSetCallNoAnswerTimeout {

    my $self = shift;
    
    carp "called without a reference" if ( ! ref($self) );
    
    return $ole->CurrentUserProfile->{CallNoAnswerTimeout} = shift;
        
}

sub userGetCallApplyForward {

    my $self = shift;
    
    carp "called without a reference" if ( ! ref($self) );
    
    return $ole->CurrentUserProfile->CallApplyCF;
    
}

sub userSetCallApplyForward {

    my $self = shift;
    
    carp "called without a reference" if ( ! ref($self) );
    
    return $ole->CurrentUserProfile->{CallApplyCF} = shift;
        
}

sub userGetSendToVoicemail {

    my $self = shift;
    
    carp "called without a reference" if ( ! ref($self) );
    
    return $ole->CurrentUserProfile->CallSendToVM;
    
}

sub userSetSendToVoicemail {

    my $self = shift;
    
    carp "called without a reference" if ( ! ref($self) );
    
    return $ole->CurrentUserProfile->{CallSendToVM} = shift;
        
}

sub userGetCallForwardRules {

    my $self = shift;
    
    carp "called without a reference" if ( ! ref($self) );
    
    return $ole->CurrentUserProfile->CallForwardRules;
    
}

sub userSetCallForwardRules {

    my $self = shift;
    
    carp "called without a reference" if ( ! ref($self) );
    
    return $ole->CurrentUserProfile->{CallForwardRules} = shift;
        
}

sub userBalance {

    my $self = shift;
    
    carp "called without a reference" if ( ! ref($self) );
    
    return $ole->CurrentUserProfile->Balance;
    
}

sub userBalanceCurrency {

    my $self = shift;
    
    carp "called without a reference" if ( ! ref($self) );
    
    return $ole->CurrentUserProfile->BalanceCurrency;
    
}

sub userBalanceText {

    my $self = shift;
    
    carp "called without a reference" if ( ! ref($self) );
    
    return $ole->CurrentUserProfile->BalanceToText;
    
}

sub userIPCountry {

    my $self = shift;
    
    carp "called without a reference" if ( ! ref($self) );
    
    return $ole->CurrentUserProfile->IPCountry;
    
}

sub userHasCallEquipment {

    my $self = shift;
    
    carp "called without a reference" if ( ! ref($self) );
    
    if ( my $user = shift ) {
    
        return $ole->User($user)->HasCallEquipment;
        
    } else {
    
        return $ole->CurrentUser->HasCallEquipment;
        
    }
    
}

sub userGetBuddyStatus {

    my $self = shift;
    
    carp "called without a reference" if ( ! ref($self) );
    
    if ( my $user = shift ) {
    
        return $ole->Convert->BuddyStatusToText($ole->User($user)->BuddyStatus);
        
    } else {
    
        return $ole->Convert->BuddyStatusToText($ole->CurrentUser->BuddyStatus);
        
    }
    
}

sub userSetBuddyStatus {

    my $self = shift;
    
    carp "called without a reference" if ( ! ref($self) );
    
    return $ole->CurrentUserProfile->{BuddyStatus} = $ole->Convert->TextToBuddyStatus(shift);
        
}

sub userGetIsAuthorized {

    my $self = shift;
    
    carp "called without a reference" if ( ! ref($self) );
    
    if ( my $user = shift ) {
    
        return $ole->User($user)->IsAuthorized;
        
    } else {
    
        return $ole->CurrentUser->IsAuthorized;
        
    }
    
}

sub userSetIsAuthorized {

    my $self = shift;
    
    carp "called without a reference" if ( ! ref($self) );
    
    if ( my $user = shift ) {
    
        return $ole->User($user)->{IsAuthorized} = shift;
        
    }
    
}

sub userGetIsBlocked {

    my $self = shift;
    
    carp "called without a reference" if ( ! ref($self) );
    
    if ( my $user = shift ) {
    
        return $ole->User($user)->IsBlocked;
        
    } else {
    
        return $ole->CurrentUser->IsBlocked;
        
    }
    
}

sub userSetIsBlocked {

    my $self = shift;
    
    carp "called without a reference" if ( ! ref($self) );
    
    if ( my $user = shift ) {
    
        return $ole->User($user)->{IsBlocked} = shift;
        
    }
    
}

sub userGetDisplayName {

    my $self = shift;
    
    carp "called without a reference" if ( ! ref($self) );
    
    if ( my $user = shift ) {
    
        return $ole->User($user)->DisplayName;
        
    }
    
}

sub userSetDisplayName {

    my $self = shift;
    
    carp "called without a reference" if ( ! ref($self) );
    
    if ( my $user = shift ) {
    
        return $ole->User($user)->{DisplayName} = shift;
        
    }
    
}

# sub userLastOnline {

    # my $self = shift;
    
    # carp "called without a reference" if ( ! ref($self) );
    
    # if ( my $user = shift ) {
    
        # return $ole->User($user)->LastOnline;
        
    # } else {
    
        # return $ole->CurrentUser->LastOnline;
        
    # }
    
# }

sub isRunning {

    my $self = shift;
    
    carp "called without a reference" if ( ! ref($self) );
    
    return $ole->Client->IsRunning;
    
}

sub start {

    my $self = shift;
    my $minimized = shift || 0;
    my $nosplash = shift || 0;
    
    carp "called without a reference" if ( ! ref($self) );
    
    return $ole->Client->Start($minimized, $nosplash);
    
}

sub shutdown {

    my $self = shift;
    
    carp "called without a reference" if ( ! ref($self) );
    
    return $ole->Client->Shutdown;
    
}

sub minimize {

    my $self = shift;
    
    carp "called without a reference" if ( ! ref($self) );
    
    return $ole->Client->Minimize;
    
}

1;

__END__
# Below is stub documentation for your module. You'd better edit it!

=head1 NAME

Win32::Skype - Perl extension for interfacing with Skype's API on Windows

=head1 SYNOPSIS

use Win32::Skype;

my $Skype = Win32::Skype->new;
$Skype->attach;

$Skype->call('echo123');

=head1 DESCRIPTION

This module provides an easy-to-use interface to Skype4COM.  The naming scheme of the functions allows scripts to be written in an almost pseudo-code kind of way.

=head1 METHODS

=head2 new()

Returns a Win32::Skype object.

    my $Skype = Win32::Skype->new;

=head2 attach()

Attaches the script to the Skype4COM API interface.

=head2 call(person1[, person2, person3, ...])

Initiates a call to the supplied Skype user or PSTN phone number.  Supplying multiple arguments will initiate a conference call.

    $Skype->call('echo123');
    # -or-
    $Skype->call('echo123', '+18004444444');

=head2 answer()

Answers an incoming call.

=head2 holdCall()

Places the current call on hold.

=head2 resumeCall()

Resumes the currently held call.

=head2 endCall()

Ends the current call.

=head2 startVideoSend()

Starts video send.

=head2 stopVideoSend()

Stops video send.

=head2 startVideoReceive()

Starts video receive.

=head2 stopVideoReceive()

Stops video receive.

=head2 userStatus([user])

Returns the status of the supplied user (or current user if one is not specified).

    print $Skype->userStatus;
    # -or-
    print $Skype->userStatus('echo123');

=head2 callStatus()

Returns the status of the current call.

=head2 dtmf(tones)

Sends DTMF (touch-tones) to the current call.  Accepts alphanumeric characters.

    $Skype->dtmf('123ABCabc');

=head2 userGetHandle([user])

Returns the handle of the supplied user (or current user if one is not specified).

    print $Skype->userGetHandle;
    # -or-
    print $Skype->userGetHandle('echo123');

=head2 userGetFullName([user])

Returns the full name of the supplied user (or current user if one is not specified).

    print $Skype->userGetFullName;
    # -or-
    print $Skype->userGetFullName('echo123');

=head2 userSetFullName(name)

Sets the full name of the current user.

    print $Skype->userSetFullName('Mr. Meowingtons');

=head2 userGetBirthday([user])

Returns the birthdate of the supplied user (or current user if one is not specified).

    print $Skype->userGetBirthday; # works fine
    # -or-
    print $Skype->userGetBirthday('echo123'); # buggy, so don't use for the time being

=head2 userSetBirthday(date)

Sets the birthdate of the current user.

    print $Skype->userSetBirthday('YYYYMMDD');

=head2 userGetSex([user])

Returns the sex of the supplied user (or current user if one is not specified).

    print $Skype->userGetSex;
    # -or-
    print $Skype->userGetSex('echo123');

=head2 userSetSex(sex)

Sets the sex of the current user.

    print $Skype->userSetSex('male');

=head2 userGetLanguage([user])

Returns the language of the supplied user (or current user if one is not specified).

    print $Skype->userGetLanguage;
    # -or-
    print $Skype->userGetLanguage('echo123');

=head2 userSetLanguage(language)

Sets the language of the current user.

    print $Skype->userSetLanguage('en');

=head2 userGetCountry([user])

Returns the country of the supplied user (or current user if one is not specified).

    print $Skype->userGetCountry;
    # -or-
    print $Skype->userGetCountry('echo123');

=head2 userSetCountry(country)

Sets the country of the current user.

    print $Skype->userSetCountry('us');

=head2 userGetProvince([user])

Returns the province of the supplied user (or current user if one is not specified).

    print $Skype->userGetProvince;
    # -or-
    print $Skype->userGetProvince('echo123');

=head2 userSetProvince(province)

Sets the province of the current user.

    print $Skype->userSetProvince('nb');

=head2 userGetCity([user])

Returns the city of the supplied user (or current user if one is not specified).

    print $Skype->userGetCity;
    # -or-
    print $Skype->userGetCity('echo123');

=head2 userSetCity(city)

Sets the city of the current user.

    print $Skype->userSetCity('Boston');

=head2 userGetPhoneHome([user])

Returns the home phone number of the supplied user (or current user if one is not specified).

    print $Skype->userGetPhoneHome;
    # -or-
    print $Skype->userGetPhoneHome('echo123');

=head2 userSetPhoneHome(number)

Sets the home phone number of the current user.

    print $Skype->userSetPhoneHome('+13334445555');

=head2 userGetPhoneOffice([user])

Returns the office phone number of the supplied user (or current user if one is not specified).

    print $Skype->userGetPhoneOffice;
    # -or-
    print $Skype->userGetPhoneOffice('echo123');

=head2 userSetPhoneOffice(number)

Sets the office phone number of the current user.

    print $Skype->userSetPhoneOffice('+13334445555');

=head2 userGetPhoneMobile([user])

Returns the mobile phone number of the supplied user (or current user if one is not specified).

    print $Skype->userGetPhoneMobile;
    # -or-
    print $Skype->userGetPhoneMobile('echo123');

=head2 userSetPhoneMobile(number)

Sets the mobile phone number of the current user.

    print $Skype->userSetPhoneMobile('+13334445555');

=head2 userGetHomepage([user])

Returns the homepage of the supplied user (or current user if one is not specified).

    print $Skype->userGetHomepage;
    # -or-
    print $Skype->userGetHomepage('echo123');

=head2 userSetHomepage(homepage)

Sets the homepage of the current user.

    print $Skype->userSetHomepage('http://www.skype.com/');

=head2 userGetAbout([user])

Returns the about text of the supplied user (or current user if one is not specified).

    print $Skype->userGetAbout;
    # -or-
    print $Skype->userGetAbout('echo123');

=head2 userSetAbout(text)

Sets the about text of the current user.

    print $Skype->userSetAbout('Hi, I enjoy haxxing gibsons and long walks on the beach.');

=head2 userGetMood([user])

Returns the mood of the supplied user (or current user if one is not specified).

    print $Skype->userGetMood;
    # -or-
    print $Skype->userGetMood('echo123');

=head2 userSetMood(text)

Sets the mood of the current user.

    print $Skype->userSetMood('mood');

=head2 userGetRichMood([user])

Returns the rich mood of the supplied user (or current user if one is not specified).

    print $Skype->userGetRichMood;
    # -or-
    print $Skype->userGetRichMood('echo123');

=head2 userSetRichMood(text)

Sets the rich mood of the current user.

    print $Skype->userSetRichMood('mood');

=head2 userGetTimezone([user])

Returns the timezone of the supplied user (or current user if one is not specified).

    print $Skype->userGetTimezone;
    # -or-
    print $Skype->userGetTimezone('echo123');

=head2 userSetTimezone(timezone)

Sets the timezone of the current user.

    print $Skype->userSetTimezone('-2');

=head2 userGetCallNoAnswerTimeout()

Returns the "call no answer timeout" of the current user.

=head2 userSetCallNoAnswerTimeout(timeout)

Sets the "call no answer timeout" of the current user.

    print $Skype->userSetCallNoAnswerTimeout('15');

=head2 userGetCallApplyForward()

Returns if the current user has call forwarding enabled.

=head2 userSetCallApplyForward(boolean)

Enables or disables the call forwarding status of the current user.

    print $Skype->userSetCallApplyForward(1);

=head2 userGetSendToVoicemail()

Returns if the current user will send calls to voicemail.

=head2 userSetSendToVoicemail(boolean)

Enables or disables sending calls to voicemail of the current user.

    print $Skype->userSetSendToVoicemail(1);

=head2 userGetCallForwardRules()

Returns the call forwarding rules of the current user.

=head2 userSetCallForwardRules(rules)

Sets the call forwarding rules of the current user.

    print $Skype->userSetCallForwardRules('rules');

=head2 userBalance()

Returns the balance in currency cents of the current user. (Unfortunately, there is no userSetBalance() function, haha.)

=head2 userBalanceCurrency()

Returns the currency code of the current user.

=head2 userBalanceText()

Returns the balance amount with currency symbol of the current user.

=head2 userIPCountry()

Returns the ISO country code by IP address of the current user.

=head2 userHasCallEquipment([user])

Returns whether or not the supplied user (or current user if one is not specified) has call equipment.  The current API implementation will always return true.

    print $Skype->userHasCallEquipment;
    # -or-
    print $Skype->userHasCallEquipment('echo123');

=head2 userGetBuddyStatus([user])

Returns the buddy status of the supplied user (or current user if one is not specified).

    print $Skype->userGetBuddyStatus;
    # -or-
    print $Skype->userGetBuddyStatus('echo123');

=head2 userSetBuddyStatus(status)

Sets the buddy status of the current user.

    print $Skype->userSetBuddyStatus('status');

=head2 userGetIsAuthorized([user])

Returns the authorization status the supplied user (or current user if one is not specified).

    print $Skype->userGetIsAuthorized;
    # -or-
    print $Skype->userGetIsAuthorized('echo123');

=head2 userSetIsAuthorized(user, boolean)

Sets the authorization status of the supplied user.

    print $Skype->userSetIsAuthorized('somedude', 1);

=head2 userGetIsBlocked([user])

Returns whether or not the supplied user (or current user if one is not specified) is blocked.

    print $Skype->userGetIsBlocked;
    # -or-
    print $Skype->userGetIsBlocked('echo123');

=head2 userSetIsBlocked(user, boolean)

Blocks or unblocks the supplied user.

    print $Skype->userSetIsBlocked('somedude', 1);

=head2 userGetDisplayName([user])

Returns the display name of supplied user (or current user if one is not specified).

    print $Skype->userGetDisplayName;
    # -or-
    print $Skype->userGetDisplayName('echo123');

=head2 userSetDisplayName(name)

Sets the mood of the current user.

    print $Skype->userSetDisplayName('Leetsauce');

=head2 isRunning()

Returns the running status of the Skype client.

    if ( $Skype->isRunning ) {
        # etc.
    }

=head2 start([boolean, boolean])

Starts the Skype client.  If the first argument is true, Skype is minimized to the system tray.  If the second argument is true, Skype does not display a splash screen on start up.

    $Skype->start;
    # -or-
    $Skype->start(1, 0);

=head2 shutdown()

Closes the Skype client.

=head2 minimize()

Minimizes the Skype client.

=head1 SEE ALSO

https://developer.skype.com/Docs/Skype4COM is the official documentation and reference to Skype4COM.  Many functions in this module use similar names as the Skype4COM functions.

=head1 AUTHOR

Michael Coppola <mncoppola@cpan.org>

=head1 BUGS

Please report any bugs or feature requests to mncoppola at cpan dot org, and I'll be sure to get back to you.

Known bugs in this module:

The userGetBirthday function does not properly return the birthdate of other users.  For example, userGetBirthday('friend') does not work, while userGetBirthday() does (returning your own birthdate).

Error handling is also not 100%, so calling certain functions without the necessary pre-requirements may break the module (for example, calling answer() when there is no incoming call).  This will be addressed as the module continues development.

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2010 by Michael Coppola

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.

=cut
