/// <summary>
/// Builds and sends the branded acknowledgement email that a candidate receives when the
/// application is submitted. The layout is table based HTML with inline styles only, so
/// that it renders the same way in Outlook, Gmail and mobile mail clients, which strip
/// style blocks and ignore flexbox and grid.
///
/// Every coloured cell carries a bgcolor attribute next to its inline background-color,
/// because the Word rendering engine behind Outlook on the desktop ignores the CSS
/// property. Rounded corners are decoration only and fall back to square corners there.
/// </summary>
codeunit 70154 "Candidate Ack. Email"
{
    var
        SubjectTxt: Label 'Application Acknowledgement - %1 Position | %2', Comment = '%1 = Position applied for, %2 = Company name';
        CompanyTaglineTxt: Label 'Technology for a better tomorrow';
        CareersLinkTxt: Label 'Careers';
        HeroTitleTxt: Label 'Application Acknowledgement';
        HeroSubtitleTxt: Label 'Thank you for taking the next step in your career with us!';
        GreetingTxt: Label 'Dear %1,', Comment = '%1 = Candidate name';
        InterestParaTxt: Label 'Thank you for your interest in pursuing a career opportunity with %1.', Comment = '%1 = Company name';
        ReceivedParaTxt: Label 'We are writing to confirm that we have successfully received your application for the position of %1, along with the supporting documents submitted with your application.', Comment = '%1 = Position applied for';
        ReviewParaTxt: Label 'Our Talent Acquisition and Recruitment Team will carefully review your profile against the requirements of the position. If your qualifications and experience match our current requirements, a member of our team will contact you regarding the subsequent stages of the recruitment process.';
        PatienceParaTxt: Label 'Please note that the review process may take some time, and we appreciate your patience during this period.';
        ClosingParaTxt: Label 'We sincerely appreciate your interest in %1 and thank you for considering us as a potential employer.', Comment = '%1 = Company name';
        SummaryTitleTxt: Label 'Application Summary';
        PositionRowTxt: Label 'Position Applied';
        StatusRowTxt: Label 'Application Status';
        DocumentsRowTxt: Label 'Documents Submitted';
        StatusReceivedTxt: Label 'Application Received';
        AttachmentCountTxt: Label '%1 Attachment(s)', Comment = '%1 = Number of attachments';
        BestRegardsTxt: Label 'Best Regards,';
        TeamNameTxt: Label 'Talent Acquisition Team';
        FooterTaglineTxt: Label 'Build Your Future<br>With Us', Comment = 'The line break splits the tagline over two lines in the email footer.';
        FooterDisclaimerTxt: Label 'This is an automated email. Please do not reply directly<br>to this message.', Comment = 'The line break splits the disclaimer over two lines in the email footer.';
        HeroImageAltTxt: Label 'Application received';

        DocOpenTok: Label '<html><head><meta http-equiv="Content-Type" content="text/html; charset=utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"></head><body style="margin:0;padding:0;background-color:#EDF1F7;"><table role="presentation" width="100%" cellpadding="0" cellspacing="0" border="0" bgcolor="#EDF1F7" style="border-collapse:collapse;background-color:#EDF1F7;"><tr><td align="center" style="padding:26px 12px;"><table role="presentation" width="640" align="center" cellpadding="0" cellspacing="0" border="0" bgcolor="#FFFFFF" style="width:640px;max-width:640px;border-collapse:collapse;background-color:#FFFFFF;border:1px solid #DDE5EF;">', Locked = true;
        HeaderTok: Label '<tr><td style="padding:18px 32px;"><table role="presentation" width="576" cellpadding="0" cellspacing="0" border="0" style="width:576px;border-collapse:collapse;"><tr><td width="38" height="38" align="center" valign="middle" bgcolor="#2B6CB8" style="width:38px;height:38px;background-color:#2B6CB8;border-radius:9px;font-family:Segoe UI,Arial,sans-serif;font-size:18px;font-weight:bold;color:#FFFFFF;">%1</td><td width="12" style="width:12px;">&nbsp;</td><td valign="middle" style="font-family:Segoe UI,Arial,sans-serif;"><div style="font-size:17px;font-weight:bold;color:#17457C;line-height:1.25;">%2</div><div style="font-size:11px;color:#8494A8;padding-top:2px;line-height:1.3;">%3</div></td><td align="right" valign="middle" style="font-family:Segoe UI,Arial,sans-serif;font-size:13px;font-weight:bold;color:#2B6CB8;">%4</td></tr></table></td></tr>', Locked = true;
        HeroTok: Label '<tr><td bgcolor="#E7EFFB" style="background-color:#E7EFFB;padding:26px 32px;font-family:Segoe UI,Arial,sans-serif;"><div style="font-size:21px;font-weight:bold;color:#17457C;line-height:1.3;">%1</div><div style="font-size:13px;color:#4A5C72;line-height:1.6;padding-top:8px;">%2</div></td></tr>', Locked = true;
        HeroImageTok: Label '<tr><td bgcolor="#E7EFFB" style="background-color:#E7EFFB;padding:24px 32px;"><table role="presentation" width="576" cellpadding="0" cellspacing="0" border="0" style="width:576px;border-collapse:collapse;"><tr><td width="330" valign="middle" style="width:330px;font-family:Segoe UI,Arial,sans-serif;"><div style="font-size:21px;font-weight:bold;color:#17457C;line-height:1.3;">%1</div><div style="font-size:13px;color:#4A5C72;line-height:1.6;padding-top:8px;">%2</div></td><td width="246" align="right" valign="middle" style="width:246px;"><img src="%3" width="220" alt="%4" style="display:block;width:220px;max-width:220px;height:auto;border:0;outline:none;text-decoration:none;" /></td></tr></table></td></tr>', Locked = true;
        BodyOpenTok: Label '<tr><td style="padding:26px 32px 6px 32px;font-family:Segoe UI,Arial,sans-serif;font-size:13px;line-height:1.75;color:#3F4D60;">', Locked = true;
        GreetingLineTok: Label '<div style="padding-bottom:16px;">%1</div>', Locked = true;
        ParagraphTok: Label '<div style="padding-bottom:14px;">%1</div>', Locked = true;
        BodyCloseTok: Label '</td></tr>', Locked = true;
        SummaryOpenTok: Label '<tr><td style="padding:14px 32px 10px 32px;"><table role="presentation" width="576" cellpadding="0" cellspacing="0" border="0" bgcolor="#EDF3FC" style="width:576px;border-collapse:collapse;background-color:#EDF3FC;"><tr><td width="105" align="center" valign="middle" bgcolor="#EDF3FC" style="width:105px;padding:22px 0;background-color:#EDF3FC;border-radius:6px 0 0 6px;"><table role="presentation" cellpadding="0" cellspacing="0" border="0" align="center" style="border-collapse:collapse;"><tr><td width="44" height="44" align="center" valign="middle" bgcolor="#2B6CB8" style="width:44px;height:44px;background-color:#2B6CB8;border-radius:22px;font-family:Segoe UI,Arial,sans-serif;font-size:20px;color:#FFFFFF;">&#10003;</td></tr></table></td>', Locked = true;
        SummaryBodyTok: Label '<td width="1" bgcolor="#D5E2F4" style="width:1px;background-color:#D5E2F4;font-size:1px;line-height:1px;">&nbsp;</td><td valign="middle" bgcolor="#EDF3FC" style="padding:22px 24px;background-color:#EDF3FC;border-radius:0 6px 6px 0;font-family:Segoe UI,Arial,sans-serif;"><div style="font-size:14px;font-weight:bold;color:#17457C;padding-bottom:12px;">%1</div><table role="presentation" cellpadding="0" cellspacing="0" border="0" style="border-collapse:collapse;font-family:Segoe UI,Arial,sans-serif;font-size:12px;color:#7A889C;">', Locked = true;
        SummaryRowTok: Label '<tr><td width="150" valign="top" style="width:150px;padding:3px 0;">%1</td><td width="16" valign="top" style="width:16px;padding:3px 0;">:</td><td valign="top" style="padding:3px 0;color:#2F3E50;font-weight:bold;">%2</td></tr>', Locked = true;
        SummaryCloseTok: Label '</table></td></tr></table></td></tr>', Locked = true;
        SignatureTok: Label '<tr><td style="padding:18px 32px 20px 32px;"><table role="presentation" width="576" cellpadding="0" cellspacing="0" border="0" style="width:576px;border-collapse:collapse;"><tr><td valign="top" style="font-family:Segoe UI,Arial,sans-serif;font-size:13px;line-height:1.7;color:#3F4D60;"><div>%1</div><div style="font-weight:bold;color:#17457C;padding-top:4px;">%2</div><div>%3</div></td></tr></table></td></tr>', Locked = true;
        ContactOpenTok: Label '<tr><td style="padding:0 32px 20px 32px;"><table role="presentation" width="576" cellpadding="0" cellspacing="0" border="0" style="width:576px;border-collapse:collapse;border-top:1px solid #E5EBF3;border-bottom:1px solid #E5EBF3;"><tr>', Locked = true;
        ContactItemTok: Label '<td align="center" valign="middle" style="padding:14px 8px;"><table role="presentation" cellpadding="0" cellspacing="0" border="0" align="center" style="border-collapse:collapse;"><tr><td width="26" height="26" align="center" valign="middle" bgcolor="#2B6CB8" style="width:26px;height:26px;background-color:#2B6CB8;border-radius:13px;font-family:Segoe UI,Arial,sans-serif;font-size:13px;color:#FFFFFF;">%1</td><td width="10" style="width:10px;">&nbsp;</td><td valign="middle" style="font-family:Segoe UI,Arial,sans-serif;font-size:12px;color:#2B6CB8;">%2</td></tr></table></td>', Locked = true;
        ContactDividerTok: Label '<td width="1" bgcolor="#E5EBF3" style="width:1px;background-color:#E5EBF3;font-size:1px;line-height:1px;">&nbsp;</td>', Locked = true;
        ContactCloseTok: Label '</tr></table></td></tr>', Locked = true;
        FooterOpenTok: Label '<tr><td bgcolor="#1C3D66" style="background-color:#1C3D66;padding:16px 32px;"><table role="presentation" width="576" cellpadding="0" cellspacing="0" border="0" style="width:576px;border-collapse:collapse;"><tr><td width="230" valign="middle" style="width:230px;"><table role="presentation" cellpadding="0" cellspacing="0" border="0" style="border-collapse:collapse;"><tr><td width="24" valign="middle" style="width:24px;font-family:Segoe UI,Arial,sans-serif;font-size:15px;color:#9FC0E4;">%1</td><td valign="middle" style="font-family:Segoe UI,Arial,sans-serif;font-size:11px;line-height:1.5;font-weight:bold;color:#FFFFFF;">%2</td></tr></table></td>', Locked = true;
        FooterCloseTok: Label '<td width="1" bgcolor="#3F6087" style="width:1px;background-color:#3F6087;font-size:1px;line-height:1px;">&nbsp;</td><td align="right" valign="middle" style="font-family:Segoe UI,Arial,sans-serif;font-size:10px;line-height:1.5;font-style:italic;color:#A9C1DD;padding-left:20px;">%1</td></tr></table></td></tr>', Locked = true;
        DocCloseTok: Label '</table></td></tr></table></body></html>', Locked = true;
        HighlightTok: Label '<span style="color:#2B6CB8;font-weight:bold;">%1</span>', Locked = true;
        MailToLinkTok: Label '<a href="mailto:%1" style="color:#2B6CB8;text-decoration:none;">%1</a>', Locked = true;
        WebLinkTok: Label '<a href="%1" style="color:#2B6CB8;text-decoration:none;">%2</a>', Locked = true;
        MailIconTok: Label '&#9993;', Locked = true;
        WebIconTok: Label '&#8853;', Locked = true;
        PhoneIconTok: Label '&#9742;', Locked = true;
        LeafIconTok: Label '&#10047;', Locked = true;
        FallbackLogoTok: Label '&#9670;', Locked = true;
        HttpsPrefixTok: Label 'https://', Locked = true;
        HttpSchemeTok: Label 'http', Locked = true;

    /// <summary>
    /// Emails the candidate a confirmation that the application was received. Does nothing
    /// when the candidate did not provide an email address.
    /// </summary>
    /// <param name="Candidate">The candidate to acknowledge.</param>
    procedure Send(var Candidate: Record "Candidate")
    var
        CompanyInformation: Record "Company Information";
        EmailImpl: Codeunit Email;
        EmailMessage: Codeunit "Email Message";
    begin
        if Candidate."Email" = '' then
            exit;

        if not CompanyInformation.Get() then
            CompanyInformation.Init();

        EmailMessage.Create(
            Candidate."Email",
            StrSubstNo(SubjectTxt, Candidate."Position Applied For", CompanyInformation.Name),
            BuildBody(Candidate, CompanyInformation),
            true);

        EmailImpl.Send(EmailMessage, Enum::"Email Scenario"::Default);
    end;

    /// <summary>
    /// Builds the HTML body of the acknowledgement email. Exposed separately so that the
    /// layout can be previewed or tested without sending anything.
    /// </summary>
    /// <param name="Candidate">The candidate to acknowledge.</param>
    /// <param name="CompanyInformation">The company details shown in the header and footer.</param>
    /// <returns>The complete HTML document.</returns>
    procedure BuildBody(var Candidate: Record "Candidate"; CompanyInformation: Record "Company Information"): Text
    var
        Html: TextBuilder;
        CompanyName: Text;
    begin
        Candidate.CalcFields("No. of Attachments");
        CompanyName := EncodeHtml(CompanyInformation.Name);

        Html.Append(DocOpenTok);
        Html.Append(StrSubstNo(HeaderTok, GetLogoInitial(CompanyInformation.Name), CompanyName, CompanyTaglineTxt, CareersLinkTxt));
        AppendHero(Html);
        AppendIntro(Html, Candidate, CompanyName);
        AppendSummary(Html, Candidate);
        Html.Append(StrSubstNo(SignatureTok, BestRegardsTxt, TeamNameTxt, CompanyName));
        AppendContactBar(Html, CompanyInformation);
        AppendFooter(Html);
        Html.Append(DocCloseTok);

        exit(Html.ToText());
    end;

    /// <summary>
    /// Writes the hero banner. The illustration is only included when a URL is configured,
    /// because a broken image placeholder looks worse than no image at all.
    /// </summary>
    local procedure AppendHero(var Html: TextBuilder)
    var
        HeroImageUrl: Text;
    begin
        HeroImageUrl := GetHeroImageUrl();
        if HeroImageUrl = '' then begin
            Html.Append(StrSubstNo(HeroTok, HeroTitleTxt, HeroSubtitleTxt));
            exit;
        end;

        Html.Append(StrSubstNo(HeroImageTok, HeroTitleTxt, HeroSubtitleTxt, EncodeHtml(HeroImageUrl), HeroImageAltTxt));
    end;

    /// <summary>
    /// Returns the absolute URL of the hero illustration shown beside the banner title.
    /// Return an empty text to render the banner as text only. The image has to be hosted
    /// somewhere the recipient can reach, because mail clients on the desktop do not render
    /// images embedded as data URIs.
    /// </summary>
    local procedure GetHeroImageUrl(): Text
    begin
        exit('');
    end;

    /// <summary>
    /// Writes the greeting and the body paragraphs, with the company name and the position
    /// picked out in the accent color.
    /// </summary>
    local procedure AppendIntro(var Html: TextBuilder; Candidate: Record "Candidate"; CompanyName: Text)
    var
        CompanyHighlight: Text;
        PositionHighlight: Text;
    begin
        CompanyHighlight := StrSubstNo(HighlightTok, CompanyName);
        PositionHighlight := StrSubstNo(HighlightTok, EncodeHtml(Candidate."Position Applied For"));

        Html.Append(BodyOpenTok);
        Html.Append(StrSubstNo(GreetingLineTok, StrSubstNo(GreetingTxt, EncodeHtml(Candidate.GetFullName()))));
        Html.Append(StrSubstNo(ParagraphTok, StrSubstNo(InterestParaTxt, CompanyHighlight)));
        Html.Append(StrSubstNo(ParagraphTok, StrSubstNo(ReceivedParaTxt, PositionHighlight)));
        Html.Append(StrSubstNo(ParagraphTok, ReviewParaTxt));
        Html.Append(StrSubstNo(ParagraphTok, PatienceParaTxt));
        Html.Append(StrSubstNo(ParagraphTok, StrSubstNo(ClosingParaTxt, CompanyHighlight)));
        Html.Append(BodyCloseTok);
    end;

    /// <summary>
    /// Writes the application summary card that repeats what was received.
    /// </summary>
    local procedure AppendSummary(var Html: TextBuilder; Candidate: Record "Candidate")
    begin
        Html.Append(SummaryOpenTok);
        Html.Append(StrSubstNo(SummaryBodyTok, SummaryTitleTxt));
        Html.Append(StrSubstNo(SummaryRowTok, PositionRowTxt, EncodeHtml(Candidate."Position Applied For")));
        Html.Append(StrSubstNo(SummaryRowTok, StatusRowTxt, StatusReceivedTxt));
        Html.Append(StrSubstNo(SummaryRowTok, DocumentsRowTxt, StrSubstNo(AttachmentCountTxt, Candidate."No. of Attachments")));
        Html.Append(SummaryCloseTok);
    end;

    /// <summary>
    /// Writes the contact bar from the company details that are filled in, and writes
    /// nothing at all when none of them are.
    /// </summary>
    local procedure AppendContactBar(var Html: TextBuilder; CompanyInformation: Record "Company Information")
    var
        ContactItems: List of [Text];
        ContactItem: Text;
        HomePageUrl: Text;
        IsFirstItem: Boolean;
    begin
        if CompanyInformation."E-Mail" <> '' then
            ContactItems.Add(StrSubstNo(ContactItemTok, MailIconTok, StrSubstNo(MailToLinkTok, EncodeHtml(CompanyInformation."E-Mail"))));

        if CompanyInformation."Home Page" <> '' then begin
            HomePageUrl := CompanyInformation."Home Page";
            if not LowerCase(HomePageUrl).StartsWith(HttpSchemeTok) then
                HomePageUrl := HttpsPrefixTok + HomePageUrl;
            ContactItems.Add(StrSubstNo(ContactItemTok, WebIconTok, StrSubstNo(WebLinkTok, EncodeHtml(HomePageUrl), EncodeHtml(CompanyInformation."Home Page"))));
        end;

        if CompanyInformation."Phone No." <> '' then
            ContactItems.Add(StrSubstNo(ContactItemTok, PhoneIconTok, EncodeHtml(CompanyInformation."Phone No.")));

        if ContactItems.Count() = 0 then
            exit;

        Html.Append(ContactOpenTok);
        IsFirstItem := true;
        foreach ContactItem in ContactItems do begin
            if not IsFirstItem then
                Html.Append(ContactDividerTok);
            Html.Append(ContactItem);
            IsFirstItem := false;
        end;
        Html.Append(ContactCloseTok);
    end;

    /// <summary>
    /// Writes the dark footer band that carries the tagline and the do not reply notice.
    /// </summary>
    local procedure AppendFooter(var Html: TextBuilder)
    begin
        Html.Append(StrSubstNo(FooterOpenTok, LeafIconTok, FooterTaglineTxt));
        Html.Append(StrSubstNo(FooterCloseTok, FooterDisclaimerTxt));
    end;

    /// <summary>
    /// Returns the letter shown in the logo tile, taken from the company name.
    /// </summary>
    local procedure GetLogoInitial(CompanyName: Text): Text
    begin
        CompanyName := DelChr(CompanyName, '<', ' ');
        if CompanyName = '' then
            exit(FallbackLogoTok);

        exit(EncodeHtml(UpperCase(CopyStr(CompanyName, 1, 1))));
    end;

    /// <summary>
    /// Escapes the characters that would otherwise break out of the surrounding markup, so
    /// that data entered on the application form cannot alter the layout of the email.
    /// </summary>
    local procedure EncodeHtml(Value: Text): Text
    begin
        Value := Value.Replace('&', '&amp;');
        Value := Value.Replace('<', '&lt;');
        Value := Value.Replace('>', '&gt;');
        Value := Value.Replace('"', '&quot;');
        exit(Value);
    end;
}
