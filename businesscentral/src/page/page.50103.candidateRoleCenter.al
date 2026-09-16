page 70143 "Candidate Role Center"
{
    Caption = 'Candidate Manager';
    PageType = RoleCenter;

    layout
    {
        area(RoleCenter)
        {
            part(Headline; "Candidate Headline")
            {
                ApplicationArea = All;
            }
            part(Activities; "Candidate Activities")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(Embedding)
        {
            action(Invitations)
            {
                ApplicationArea = All;
                Caption = 'Registration Invitations';
                RunObject = page "Candidate Invitation List";
                ToolTip = 'Open the candidates who are invited to the online application form and have not submitted it yet.';
            }
            action(Applications)
            {
                ApplicationArea = All;
                Caption = 'Candidate Applications';
                RunObject = page "Candidate Application List";
                ToolTip = 'Open the submitted job applications.';
            }
        }

        area(Sections)
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
                action(ScheduledInterviews)
                {
                    ApplicationArea = All;
                    Caption = 'Scheduled Interviews';
                    Image = Calendar;
                    RunObject = page "Candidate List";
                    RunPageView = where("Interview Date" = filter('<>'''''));
                    ToolTip = 'Open the candidates that have an interview date.';
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

        area(Creation)
        {
            action(NewInvitation)
            {
                ApplicationArea = All;
                Caption = 'Registration Invitation';
                Image = New;
                RunObject = page "Candidate Invitation Card";
                RunPageMode = Create;
                ToolTip = 'Invite a new candidate to fill in the online application form.';
            }
            action(NewCandidate)
            {
                ApplicationArea = All;
                Caption = 'Job Application';
                Image = New;
                RunObject = page "Candidate Card";
                RunPageMode = Create;
                ToolTip = 'Enter a job application on behalf of a candidate, for example one handed in on paper.';
            }
        }

        area(Processing)
        {
            group(InterviewPlanning)
            {
                Caption = 'Interview Planning';
                Image = Planning;

                action(TodaysInterviews)
                {
                    ApplicationArea = All;
                    Caption = 'Today''s Interviews';
                    Image = Timesheet;
                    RunObject = page "Candidate List";
                    RunPageView = sorting("Interview Date");
                    ToolTip = 'Open the candidate list sorted by interview date.';
                }
            }
        }
    }
}
