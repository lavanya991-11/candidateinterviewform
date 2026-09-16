/// <summary>
/// Sends a candidate the personal link to the online application form. HR enters the
/// candidate email and the HR email on the Candidate Card, and the link goes to the
/// candidate with a copy to HR. When the candidate submits the form, it updates this
/// same record instead of creating a new one.
/// </summary>
codeunit 70156 "Candidate Registration"
{
    var
        SubjectTxt: Label 'Complete Your Job Application | %1', Comment = '%1 = Company name';
        HeroTitleTxt: Label 'Complete Your Registration';
        HeroSubtitleTxt: Label 'You are invited to apply for a career opportunity with us.';
        GreetingTxt: Label 'Dear %1,', Comment = '%1 = Candidate name';
        DefaultGreetingNameTxt: Label 'Candidate';
        InviteParaTxt: Label 'Thank you for your interest in a career opportunity with %1.', Comment = '%1 = Company name';
        InvitePositionParaTxt: Label 'Thank you for your interest in the position of %1 with %2.', Comment = '%1 = Position applied for, %2 = Company name';
        InstructionParaTxt: Label 'To take your application forward, please complete the registration form using the button below. Keep your photo and graduation certificates ready, because you need to attach them to the form.';
        ReferenceParaTxt: Label 'Your reference number is %1. Please quote it in any correspondence with us.', Comment = '%1 = Entry No. of the candidate';
        LinkFallbackParaTxt: Label 'If the button does not work, copy this link into your browser: %1', Comment = '%1 = Registration link';
        PersonalLinkParaTxt: Label 'This link is personal to you and can only be used once. Please do not share it.';
        ButtonCaptionTxt: Label 'Complete Registration';
        AlreadySubmittedErr: Label 'The application of %1 was already submitted on %2, so there is nothing left to register.', Comment = '%1 = Candidate name, %2 = Submission date and time';
        ResendQst: Label 'A registration link was already sent on %1. Do you want to send a new link? The earlier link will stop working.', Comment = '%1 = Date and time the link was sent';
        SendFailedErr: Label 'The registration link could not be sent. %1', Comment = '%1 = Error message from the email account';
        SentMsg: Label 'The registration link was sent to %1, with a copy to %2.', Comment = '%1 = Candidate email, %2 = HR email';
        RegistrationQueryTok: Label 'registration=%1', Locked = true;
        LinkTok: Label '<a href="%1" style="color:#2B6CB8;word-break:break-all;">%1</a>', Locked = true;
        ButtonTok: Label '<tr><td align="center" style="padding:4px 32px 22px 32px;"><table role="presentation" cellpadding="0" cellspacing="0" border="0" align="center" style="border-collapse:collapse;"><tr><td align="center" bgcolor="#2B6CB8" style="background-color:#2B6CB8;border-radius:6px;"><a href="%1" style="display:inline-block;padding:12px 28px;font-family:Segoe UI,Arial,sans-serif;font-size:14px;font-weight:bold;color:#FFFFFF;text-decoration:none;">%2</a></td></tr></table></td></tr>', Locked = true;

    /// <summary>
    /// Emails the candidate a new registration link, with a copy to the HR email address,
    /// and marks the record as Registration Sent. Asks first when a link was already sent,
    /// because the new link replaces the earlier one.
    /// </summary>
    /// <param name="Candidate">The candidate to invite.</param>
    procedure SendInvitation(var Candidate: Record "Candidate")
    var
        CompanyInformation: Record "Company Information";
        Email: Codeunit Email;
        EmailMessage: Codeunit "Email Message";
        ToRecipients: List of [Text];
        CcRecipients: List of [Text];
        BccRecipients: List of [Text];
        RegistrationLink: Text;
    begin
        CheckCanInvite(Candidate);

        if Candidate."Registration Sent On" <> 0DT then
            if GuiAllowed() then
                if not Confirm(ResendQst, false, Candidate."Registration Sent On") then
                    exit;

        if not CompanyInformation.Get() then
            CompanyInformation.Init();

        Candidate."Registration Token" := CreateGuid();
        RegistrationLink := GetRegistrationLink(Candidate);

        ToRecipients.Add(Candidate."Email");
        CcRecipients.Add(Candidate."HR Email");
        EmailMessage.Create(
            ToRecipients,
            StrSubstNo(SubjectTxt, CompanyInformation.Name),
            BuildBody(Candidate, CompanyInformation, RegistrationLink),
            true,
            CcRecipients,
            BccRecipients);

        // Sent before the record is changed: sending commits the outbox entry, so a failure
        // cannot roll back a change made earlier, and the earlier link must keep working
        // until a new one has actually gone out.
        if not Email.Send(EmailMessage, Enum::"Email Scenario"::Default) then
            Error(SendFailedErr, GetLastErrorText());

        Candidate."Registration Sent On" := CurrentDateTime();
        Candidate."Registration Sent By" := CopyStr(UserId(), 1, MaxStrLen(Candidate."Registration Sent By"));
        Candidate."Application Status" := Candidate."Application Status"::Invited;
        Candidate.Modify(true);

        if GuiAllowed() then
            Message(SentMsg, Candidate."Email", Candidate."HR Email");
    end;

    /// <summary>
    /// Returns the link that opens the application form for this candidate.
    /// </summary>
    /// <param name="Candidate">The candidate the link is for. The registration token must be set.</param>
    /// <returns>The registration link.</returns>
    procedure GetRegistrationLink(Candidate: Record "Candidate"): Text
    var
        CandidateSetup: Record "Candidate Setup";
        FormUrl: Text;
        Separator: Text;
    begin
        FormUrl := CandidateSetup.GetRegistrationFormUrl();

        Separator := '?';
        if FormUrl.Contains('?') then
            Separator := '&';

        // Format 4 gives the plain lowercase form, without the braces a GUID usually carries.
        exit(FormUrl + Separator + StrSubstNo(RegistrationQueryTok, Format(Candidate."Registration Token", 0, 4).ToLower()));
    end;

    /// <summary>
    /// Builds the HTML body of the invitation. Exposed separately so that the layout can be
    /// previewed or tested without sending anything.
    /// </summary>
    /// <param name="Candidate">The candidate to invite.</param>
    /// <param name="CompanyInformation">The company details shown in the header and footer.</param>
    /// <param name="RegistrationLink">The link that opens the application form.</param>
    /// <returns>The complete HTML document.</returns>
    procedure BuildBody(Candidate: Record "Candidate"; CompanyInformation: Record "Company Information"; RegistrationLink: Text): Text
    var
        CandidateAckEmail: Codeunit "Candidate Ack. Email";
        Paragraphs: List of [Text];
        Greeting: Text;
        CompanyHighlight: Text;
        EncodedLink: Text;
    begin
        CompanyHighlight := CandidateAckEmail.Highlight(CompanyInformation.Name);
        EncodedLink := CandidateAckEmail.EncodeHtml(RegistrationLink);

        if Candidate."Position Applied For" <> '' then
            Paragraphs.Add(StrSubstNo(InvitePositionParaTxt, CandidateAckEmail.Highlight(Candidate."Position Applied For"), CompanyHighlight))
        else
            Paragraphs.Add(StrSubstNo(InviteParaTxt, CompanyHighlight));
        Paragraphs.Add(InstructionParaTxt);
        Paragraphs.Add(StrSubstNo(ReferenceParaTxt, CandidateAckEmail.Highlight(Format(Candidate."Entry No."))));

        // HR may enter no more than the email address; the candidate fills in the name.
        Greeting := DefaultGreetingNameTxt;
        if Candidate."Candidate Name" <> '' then
            Greeting := Candidate.GetFullName();

        // The paragraphs after the button repeat the link as text, for mail clients that
        // strip or block the button.
        exit(CandidateAckEmail.BuildLayout(
            CompanyInformation, HeroTitleTxt, HeroSubtitleTxt,
            StrSubstNo(GreetingTxt, CandidateAckEmail.EncodeHtml(Greeting)),
            Paragraphs,
            StrSubstNo(ButtonTok, EncodedLink, ButtonCaptionTxt) +
            BuildTrailingParagraphs(StrSubstNo(LinkFallbackParaTxt, StrSubstNo(LinkTok, EncodedLink)))));
    end;

    local procedure BuildTrailingParagraphs(LinkParagraph: Text): Text
    var
        TrailingOpenTok: Label '<tr><td style="padding:0 32px 6px 32px;font-family:Segoe UI,Arial,sans-serif;font-size:12px;line-height:1.7;color:#7A889C;">', Locked = true;
        TrailingParagraphTok: Label '<div style="padding-bottom:10px;">%1</div>', Locked = true;
        TrailingCloseTok: Label '</td></tr>', Locked = true;
    begin
        exit(
            TrailingOpenTok +
            StrSubstNo(TrailingParagraphTok, LinkParagraph) +
            StrSubstNo(TrailingParagraphTok, PersonalLinkParaTxt) +
            TrailingCloseTok);
    end;

    local procedure CheckCanInvite(var Candidate: Record "Candidate")
    begin
        if Candidate."Application Status" = Candidate."Application Status"::Submitted then
            Error(AlreadySubmittedErr, Candidate."Candidate Name", Candidate."Submitted On");

        Candidate.TestField("Email");
        Candidate.TestField("HR Email");
    end;
}
