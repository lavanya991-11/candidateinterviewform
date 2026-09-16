page 70144 "Candidate Activities"
{
    Caption = 'Candidate Activities';
    PageType = CardPart;
    ApplicationArea = All;
    RefreshOnActivate = true;

    layout
    {
        area(Content)
        {
            cuegroup(Candidates)
            {
                Caption = 'Candidates';

                field(TotalCandidates; TotalCandidatesCount)
                {
                    ApplicationArea = All;
                    Caption = 'Total Candidates';
                    StyleExpr = TotalCandidatesStyle;
                    ToolTip = 'Specifies the total number of registered candidates.';

                    trigger OnDrillDown()
                    var
                        Candidate: Record "Candidate";
                    begin
                        Candidate.Reset();
                        ShowCandidates(Candidate);
                    end;
                }
                field(NewApplications; NewApplicationsCount)
                {
                    ApplicationArea = All;
                    Caption = 'Applications This Month';
                    StyleExpr = NewApplicationsStyle;
                    ToolTip = 'Specifies the number of candidates who applied in the current month.';

                    trigger OnDrillDown()
                    var
                        Candidate: Record "Candidate";
                    begin
                        Candidate.SetRange("Application Date", CalcDate('<-CM>', ReferenceDate()), ReferenceDate());
                        ShowCandidates(Candidate);
                    end;
                }
            }
            cuegroup(Registrations)
            {
                Caption = 'Registrations';

                field(LinksNotSent; LinksNotSentCount)
                {
                    ApplicationArea = All;
                    Caption = 'Links Not Sent';
                    StyleExpr = LinksNotSentStyle;
                    ToolTip = 'Specifies the number of invited candidates whose registration link has not been sent yet.';

                    trigger OnDrillDown()
                    var
                        Candidate: Record "Candidate";
                    begin
                        SetLinksNotSentFilter(Candidate);
                        ShowInvitations(Candidate);
                    end;
                }
                field(WaitingForCandidate; WaitingForCandidateCount)
                {
                    ApplicationArea = All;
                    Caption = 'Waiting for Candidate';
                    StyleExpr = WaitingForCandidateStyle;
                    ToolTip = 'Specifies the number of candidates who were sent a registration link and have not submitted the form yet.';

                    trigger OnDrillDown()
                    var
                        Candidate: Record "Candidate";
                    begin
                        Candidate.SetRange("Application Status", Candidate."Application Status"::Invited);
                        ShowInvitations(Candidate);
                    end;
                }
                field(SubmittedToday; SubmittedTodayCount)
                {
                    ApplicationArea = All;
                    Caption = 'Submitted Today';
                    StyleExpr = SubmittedTodayStyle;
                    ToolTip = 'Specifies the number of applications submitted today.';

                    trigger OnDrillDown()
                    var
                        Candidate: Record "Candidate";
                    begin
                        SetSubmittedTodayFilter(Candidate);
                        ShowApplications(Candidate);
                    end;
                }
            }
            cuegroup(Interviews)
            {
                Caption = 'Interviews';

                field(InterviewsToday; InterviewsTodayCount)
                {
                    ApplicationArea = All;
                    Caption = 'Interviews Today';
                    StyleExpr = InterviewsTodayStyle;
                    ToolTip = 'Specifies the number of interviews scheduled for today.';

                    trigger OnDrillDown()
                    var
                        Candidate: Record "Candidate";
                    begin
                        Candidate.SetRange("Interview Date", ReferenceDate());
                        ShowCandidates(Candidate);
                    end;
                }
                field(InterviewsScheduled; InterviewsScheduledCount)
                {
                    ApplicationArea = All;
                    Caption = 'Interviews Scheduled';
                    StyleExpr = InterviewsScheduledStyle;
                    ToolTip = 'Specifies the number of candidates that have an interview date.';

                    trigger OnDrillDown()
                    var
                        Candidate: Record "Candidate";
                    begin
                        Candidate.SetFilter("Interview Date", NotBlankDateTok);
                        ShowCandidates(Candidate);
                    end;
                }
                field(InterviewsNotScheduled; InterviewsNotScheduledCount)
                {
                    ApplicationArea = All;
                    Caption = 'Interviews Not Scheduled';
                    StyleExpr = NotScheduledStyle;
                    ToolTip = 'Specifies the number of candidates that still need an interview date.';

                    trigger OnDrillDown()
                    var
                        Candidate: Record "Candidate";
                    begin
                        Candidate.SetFilter("Interview Date", BlankDateTok);
                        ShowCandidates(Candidate);
                    end;
                }
            }
            cuegroup(QuickActions)
            {
                Caption = 'Quick Actions';

                actions
                {
                    action(NewInvitation)
                    {
                        ApplicationArea = All;
                        Caption = 'New Registration Invitation';
                        RunObject = page "Candidate Invitation Card";
                        RunPageMode = Create;
                        ToolTip = 'Invite a new candidate to fill in the online application form.';
                    }
                    action(NewCandidate)
                    {
                        ApplicationArea = All;
                        Caption = 'New Job Application';
                        RunObject = page "Candidate Card";
                        RunPageMode = Create;
                        ToolTip = 'Enter a job application on behalf of a candidate, for example one handed in on paper.';
                    }
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(SetUpCues)
            {
                ApplicationArea = All;
                Caption = 'Set Up Cues';
                Image = Setup;
                ToolTip = 'Set up the cues (status tiles) related to the role.';

                trigger OnAction()
                var
                    CuesAndKpis: Codeunit "Cues And KPIs";
                begin
                    CuesAndKpis.OpenCustomizePageForCurrentUser(Database::"Candidate Cue");
                end;
            }
        }
    }

    var
        TotalCandidatesCount: Integer;
        NewApplicationsCount: Integer;
        InterviewsTodayCount: Integer;
        InterviewsScheduledCount: Integer;
        InterviewsNotScheduledCount: Integer;
        LinksNotSentCount: Integer;
        WaitingForCandidateCount: Integer;
        SubmittedTodayCount: Integer;
        TotalCandidatesStyle: Text;
        NewApplicationsStyle: Text;
        InterviewsTodayStyle: Text;
        InterviewsScheduledStyle: Text;
        NotScheduledStyle: Text;
        LinksNotSentStyle: Text;
        WaitingForCandidateStyle: Text;
        SubmittedTodayStyle: Text;
        // Blank dates are filtered as text so that no 0D value is ever sent to the client.
        BlankDateTok: Label '''''', Locked = true;
        NotBlankDateTok: Label '<>''''', Locked = true;

    trigger OnOpenPage()
    begin
        InsertDefaultCueSetup();
        UpdateCountsAndStyles();
    end;

    trigger OnAfterGetCurrRecord()
    begin
        UpdateCountsAndStyles();
    end;

    local procedure ReferenceDate(): Date
    begin
        if WorkDate() = 0D then
            exit(Today());
        exit(WorkDate());
    end;

    local procedure ShowCandidates(var Candidate: Record "Candidate")
    var
        CandidateList: Page "Candidate List";
    begin
        CandidateList.SetTableView(Candidate);
        CandidateList.Run();
    end;

    local procedure ShowInvitations(var Candidate: Record "Candidate")
    var
        InvitationList: Page "Candidate Invitation List";
    begin
        InvitationList.SetTableView(Candidate);
        InvitationList.Run();
    end;

    local procedure ShowApplications(var Candidate: Record "Candidate")
    var
        ApplicationList: Page "Candidate Application List";
    begin
        ApplicationList.SetTableView(Candidate);
        ApplicationList.Run();
    end;

    local procedure SetLinksNotSentFilter(var Candidate: Record "Candidate")
    begin
        Candidate.SetRange("Application Status", Candidate."Application Status"::Draft);
        Candidate.SetFilter("Registration Sent On", BlankDateTok);
    end;

    local procedure SetSubmittedTodayFilter(var Candidate: Record "Candidate")
    begin
        Candidate.SetRange("Application Status", Candidate."Application Status"::Submitted);
        Candidate.SetRange("Submitted On", CreateDateTime(ReferenceDate(), 0T), CreateDateTime(ReferenceDate(), 235959.999T));
    end;

    local procedure UpdateCountsAndStyles()
    var
        Candidate: Record "Candidate";
    begin
        Candidate.Reset();
        TotalCandidatesCount := Candidate.Count();

        Candidate.SetRange("Application Date", CalcDate('<-CM>', ReferenceDate()), ReferenceDate());
        NewApplicationsCount := Candidate.Count();

        Candidate.Reset();
        Candidate.SetRange("Interview Date", ReferenceDate());
        InterviewsTodayCount := Candidate.Count();

        Candidate.Reset();
        Candidate.SetFilter("Interview Date", NotBlankDateTok);
        InterviewsScheduledCount := Candidate.Count();

        Candidate.Reset();
        Candidate.SetFilter("Interview Date", BlankDateTok);
        InterviewsNotScheduledCount := Candidate.Count();

        Candidate.Reset();
        SetLinksNotSentFilter(Candidate);
        LinksNotSentCount := Candidate.Count();

        Candidate.Reset();
        Candidate.SetRange("Application Status", Candidate."Application Status"::Invited);
        WaitingForCandidateCount := Candidate.Count();

        Candidate.Reset();
        SetSubmittedTodayFilter(Candidate);
        SubmittedTodayCount := Candidate.Count();

        UpdateStyles();
    end;

    local procedure InsertDefaultCueSetup()
    var
        TempCandidateCue: Record "Candidate Cue" temporary;
        CuesAndKpis: Codeunit "Cues And KPIs";
    begin
        // The style is picked with "value < Threshold 1", so Threshold 1 is the first
        // count that is not an empty list, and Threshold 2 - which the platform requires
        // to be higher - is the count at which the tile changes again.
        if not CuesAndKpis.PersonalizedCueSetupExistsForCurrentUser(Database::"Candidate Cue", TempCandidateCue.FieldNo("Total Candidates")) then
            CuesAndKpis.InsertData(Database::"Candidate Cue", TempCandidateCue.FieldNo("Total Candidates"),
                Enum::"Cues And KPIs Style"::Subordinate, 1, Enum::"Cues And KPIs Style"::Ambiguous, 10, Enum::"Cues And KPIs Style"::Favorable);

        if not CuesAndKpis.PersonalizedCueSetupExistsForCurrentUser(Database::"Candidate Cue", TempCandidateCue.FieldNo("New Applications")) then
            CuesAndKpis.InsertData(Database::"Candidate Cue", TempCandidateCue.FieldNo("New Applications"),
                Enum::"Cues And KPIs Style"::Subordinate, 1, Enum::"Cues And KPIs Style"::Ambiguous, 5, Enum::"Cues And KPIs Style"::Favorable);

        // A quiet day is neutral, a normal day is good, more than five interviews is a heavy day.
        if not CuesAndKpis.PersonalizedCueSetupExistsForCurrentUser(Database::"Candidate Cue", TempCandidateCue.FieldNo("Interviews Today")) then
            CuesAndKpis.InsertData(Database::"Candidate Cue", TempCandidateCue.FieldNo("Interviews Today"),
                Enum::"Cues And KPIs Style"::Subordinate, 1, Enum::"Cues And KPIs Style"::Favorable, 5, Enum::"Cues And KPIs Style"::Ambiguous);

        if not CuesAndKpis.PersonalizedCueSetupExistsForCurrentUser(Database::"Candidate Cue", TempCandidateCue.FieldNo("Interviews Scheduled")) then
            CuesAndKpis.InsertData(Database::"Candidate Cue", TempCandidateCue.FieldNo("Interviews Scheduled"),
                Enum::"Cues And KPIs Style"::Subordinate, 1, Enum::"Cues And KPIs Style"::Ambiguous, 5, Enum::"Cues And KPIs Style"::Favorable);

        // Nothing waiting is good, a small backlog needs attention, more than five is bad.
        if not CuesAndKpis.PersonalizedCueSetupExistsForCurrentUser(Database::"Candidate Cue", TempCandidateCue.FieldNo("Interviews Not Scheduled")) then
            CuesAndKpis.InsertData(Database::"Candidate Cue", TempCandidateCue.FieldNo("Interviews Not Scheduled"),
                Enum::"Cues And KPIs Style"::Favorable, 1, Enum::"Cues And KPIs Style"::Ambiguous, 5, Enum::"Cues And KPIs Style"::Unfavorable);

        // A link that is not sent is work waiting on HR, so any count needs attention.
        if not CuesAndKpis.PersonalizedCueSetupExistsForCurrentUser(Database::"Candidate Cue", TempCandidateCue.FieldNo("Links Not Sent")) then
            CuesAndKpis.InsertData(Database::"Candidate Cue", TempCandidateCue.FieldNo("Links Not Sent"),
                Enum::"Cues And KPIs Style"::Favorable, 1, Enum::"Cues And KPIs Style"::Ambiguous, 5, Enum::"Cues And KPIs Style"::Unfavorable);

        // Candidates take a few days to reply, so only a long queue is a concern.
        if not CuesAndKpis.PersonalizedCueSetupExistsForCurrentUser(Database::"Candidate Cue", TempCandidateCue.FieldNo("Waiting for Candidate")) then
            CuesAndKpis.InsertData(Database::"Candidate Cue", TempCandidateCue.FieldNo("Waiting for Candidate"),
                Enum::"Cues And KPIs Style"::Subordinate, 1, Enum::"Cues And KPIs Style"::Ambiguous, 10, Enum::"Cues And KPIs Style"::Unfavorable);

        if not CuesAndKpis.PersonalizedCueSetupExistsForCurrentUser(Database::"Candidate Cue", TempCandidateCue.FieldNo("Submitted Today")) then
            CuesAndKpis.InsertData(Database::"Candidate Cue", TempCandidateCue.FieldNo("Submitted Today"),
                Enum::"Cues And KPIs Style"::Subordinate, 1, Enum::"Cues And KPIs Style"::Favorable, 10, Enum::"Cues And KPIs Style"::Favorable);
    end;

    local procedure UpdateStyles()
    var
        TempCandidateCue: Record "Candidate Cue" temporary;
        CuesAndKpis: Codeunit "Cues And KPIs";
        StyleEnum: Enum "Cues And KPIs Style";
    begin
        CuesAndKpis.SetCueStyle(Database::"Candidate Cue", TempCandidateCue.FieldNo("Total Candidates"), TotalCandidatesCount, StyleEnum);
        TotalCandidatesStyle := CuesAndKpis.ConvertStyleToStyleText(StyleEnum);

        CuesAndKpis.SetCueStyle(Database::"Candidate Cue", TempCandidateCue.FieldNo("New Applications"), NewApplicationsCount, StyleEnum);
        NewApplicationsStyle := CuesAndKpis.ConvertStyleToStyleText(StyleEnum);

        CuesAndKpis.SetCueStyle(Database::"Candidate Cue", TempCandidateCue.FieldNo("Interviews Today"), InterviewsTodayCount, StyleEnum);
        InterviewsTodayStyle := CuesAndKpis.ConvertStyleToStyleText(StyleEnum);

        CuesAndKpis.SetCueStyle(Database::"Candidate Cue", TempCandidateCue.FieldNo("Interviews Scheduled"), InterviewsScheduledCount, StyleEnum);
        InterviewsScheduledStyle := CuesAndKpis.ConvertStyleToStyleText(StyleEnum);

        CuesAndKpis.SetCueStyle(Database::"Candidate Cue", TempCandidateCue.FieldNo("Interviews Not Scheduled"), InterviewsNotScheduledCount, StyleEnum);
        NotScheduledStyle := CuesAndKpis.ConvertStyleToStyleText(StyleEnum);

        CuesAndKpis.SetCueStyle(Database::"Candidate Cue", TempCandidateCue.FieldNo("Links Not Sent"), LinksNotSentCount, StyleEnum);
        LinksNotSentStyle := CuesAndKpis.ConvertStyleToStyleText(StyleEnum);

        CuesAndKpis.SetCueStyle(Database::"Candidate Cue", TempCandidateCue.FieldNo("Waiting for Candidate"), WaitingForCandidateCount, StyleEnum);
        WaitingForCandidateStyle := CuesAndKpis.ConvertStyleToStyleText(StyleEnum);

        CuesAndKpis.SetCueStyle(Database::"Candidate Cue", TempCandidateCue.FieldNo("Submitted Today"), SubmittedTodayCount, StyleEnum);
        SubmittedTodayStyle := CuesAndKpis.ConvertStyleToStyleText(StyleEnum);
    end;
}
