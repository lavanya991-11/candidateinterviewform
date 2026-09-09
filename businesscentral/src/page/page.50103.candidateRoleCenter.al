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
            action(Candidates)
            {
                ApplicationArea = All;
                Caption = 'Candidates';
                RunObject = page "Candidate List";
                ToolTip = 'Open the list of registered candidates.';
            }
        }

        area(Sections)
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
            action(NewCandidate)
            {
                ApplicationArea = All;
                Caption = 'Candidate';
                Image = New;
                RunObject = page "Candidate Card";
                RunPageMode = Create;
                ToolTip = 'Register a new candidate.';
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
