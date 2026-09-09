page 70145 "Candidate Headline"
{
    Caption = 'Headline';
    PageType = HeadlinePart;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            group(Control1)
            {
                Editable = false;

                field(GreetingText; GreetingTxt)
                {
                    ApplicationArea = All;
                    Caption = ' ';
                    DrillDown = false;
                    Editable = false;
                    ToolTip = 'Specifies a greeting for the current user.';
                }
                field(LatestCandidateText; LatestCandidateTxt)
                {
                    ApplicationArea = All;
                    Caption = ' ';
                    Editable = false;
                    Visible = HasCandidates;
                    ToolTip = 'Specifies the most recently registered candidate. Choose the text to open the candidate.';

                    trigger OnDrillDown()
                    var
                        Candidate: Record "Candidate";
                    begin
                        if Candidate.Get(LatestEntryNo) then
                            Page.Run(Page::"Candidate Card", Candidate);
                    end;
                }
                field(WaitingText; WaitingTxt)
                {
                    ApplicationArea = All;
                    Caption = ' ';
                    Editable = false;
                    Visible = HasCandidates;
                    ToolTip = 'Specifies how many candidates are still waiting for an interview date.';

                    trigger OnDrillDown()
                    var
                        Candidate: Record "Candidate";
                    begin
                        Candidate.SetFilter("Interview Date", BlankDateTok);
                        Page.Run(Page::"Candidate List", Candidate);
                    end;
                }
            }
        }
    }

    var
        GreetingTxt: Text;
        LatestCandidateTxt: Text;
        WaitingTxt: Text;
        LatestEntryNo: Integer;
        HasCandidates: Boolean;
        GreetingLbl: Label 'Good day, %1', Comment = '%1 = user name';
        LatestCandidateLbl: Label 'Latest candidate: %1', Comment = '%1 = candidate name';
        LatestCandidateForLbl: Label 'Latest candidate: %1 - %2', Comment = '%1 = candidate name, %2 = position applied for';
        WaitingLbl: Label '%1 candidate(s) waiting for an interview date.', Comment = '%1 = number of candidates';
        AllScheduledLbl: Label 'All candidates have an interview date scheduled.';
        // Blank dates are filtered as text so that no 0D value is ever sent to the client.
        BlankDateTok: Label '''''', Locked = true;

    trigger OnOpenPage()
    begin
        SetHeadlines();
    end;

    local procedure SetHeadlines()
    var
        Candidate: Record "Candidate";
        WaitingCount: Integer;
    begin
        GreetingTxt := StrSubstNo(GreetingLbl, UserId());

        Candidate.SetCurrentKey("Entry No.");
        HasCandidates := Candidate.FindLast();
        if not HasCandidates then
            exit;

        LatestEntryNo := Candidate."Entry No.";
        if Candidate."Position Applied For" <> '' then
            LatestCandidateTxt := StrSubstNo(LatestCandidateForLbl, Candidate."Candidate Name", Candidate."Position Applied For")
        else
            LatestCandidateTxt := StrSubstNo(LatestCandidateLbl, Candidate."Candidate Name");

        Candidate.Reset();
        Candidate.SetFilter("Interview Date", BlankDateTok);
        WaitingCount := Candidate.Count();
        if WaitingCount > 0 then
            WaitingTxt := StrSubstNo(WaitingLbl, WaitingCount)
        else
            WaitingTxt := AllScheduledLbl;
    end;
}
