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
                    action(NewCandidate)
                    {
                        ApplicationArea = All;
                        Caption = 'New Candidate';
                        RunObject = page "Candidate Card";
                        RunPageMode = Create;
                        ToolTip = 'Register a new candidate.';
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
        TotalCandidatesStyle: Text;
        NewApplicationsStyle: Text;
        InterviewsTodayStyle: Text;
        InterviewsScheduledStyle: Text;
        NotScheduledStyle: Text;
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
    end;
}
