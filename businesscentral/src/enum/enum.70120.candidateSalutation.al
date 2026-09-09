/// <summary>
/// The salutation of a candidate.
/// </summary>
enum 70120 "Candidate Salutation"
{
    Extensible = true;

    value(0; " ")
    {
        Caption = ' ', Locked = true;
    }
    value(1; Mr)
    {
        Caption = 'Mr.';
    }
    value(2; Mrs)
    {
        Caption = 'Mrs.';
    }
    value(3; Ms)
    {
        Caption = 'Ms.';
    }
    value(4; Miss)
    {
        Caption = 'Miss';
    }
    value(5; Dr)
    {
        Caption = 'Dr.';
    }
}
