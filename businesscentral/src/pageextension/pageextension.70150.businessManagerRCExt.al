pageextension 70150 "Candidate BM Role Center Ext" extends "Business Manager Role Center"
{
    layout
    {
        addlast(rolecenter)
        {
            part(CandidateActivities; "Candidate Activities")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        addlast(sections)
        {
            group(Recruitment)
            {
                Caption = 'Recruitment';
                Image = Job;

                action(CandidateList)
                {
                    ApplicationArea = All;
                    Caption = 'Candidates';
                    Image = User;
                    RunObject = page "Candidate List";
                    ToolTip = 'Open the list of registered candidates.';
                }
                action(CandidatesWithoutInterview)
                {
                    ApplicationArea = All;
                    Caption = 'Candidates Without Interview';
                    Image = CalendarMachine;
                    RunObject = page "Candidate List";
                    RunPageView = where("Interview Date" = filter(''));
                    ToolTip = 'Open the candidates that still need an interview date.';
                }
            }
        }
    }
}
