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

                action(InvitationList)
                {
                    ApplicationArea = All;
                    Caption = 'Registration Invitations';
                    Image = SendTo;
                    RunObject = page "Candidate Invitation List";
                    ToolTip = 'Open the candidates who are invited to the online application form and have not submitted it yet.';
                }
                action(ApplicationList)
                {
                    ApplicationArea = All;
                    Caption = 'Candidate Applications';
                    Image = Approve;
                    RunObject = page "Candidate Application List";
                    ToolTip = 'Open the submitted job applications.';
                }
                action(CandidateList)
                {
                    ApplicationArea = All;
                    Caption = 'All Candidates';
                    Image = User;
                    RunObject = page "Candidate List";
                    ToolTip = 'Open every candidate, whatever the status of the application.';
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
