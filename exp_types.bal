// Prompt 1
type Session record {
    string title;
    string date;
    string time;
    string location;
    string[] speakers;
    string description;
};

type Product record {
    string name;
    string description;
};

type Customer record {
    string companyName;
    string usageSummary;
};

type User record {
    string attendeeName;
    string company;
    string role;
};

type ConferenceData record {
    Session[] sessions;
    Product[] products;
    Customer customer;
    User user;
};

// Prompt 2
type Match record {
    string id;
    string reason;
    string[] tags;
};

// Prompt 3
type reviewAverage int[];

// Prompt 4
type ReviewSingle string[];

// Prompt 5
type ReviewSingleWord string;

// Prompt 6
type ReviewSingleInteger int;

// Prompt 7
type Order record {
    string OrderID;
    string ProductName;
    int Quantity;
    decimal Price;
    string Date;
};

type CustomerDetails record {
    string Name;
    int Age;
    string Email;
    string Address;
    string Phone;
    Order[] Orders;
};

type Employee record {
    string EmployeeID;
    string Name;
    string Position;
    string Department;
    string HireDate;
    string[] Skills;
};

type Company record {
    string CompanyName;
    string Founded;
    string Location;
    int Employees;
    decimal AnnualRevenue;
    string Industry;
};

type BusinessData record {
    CustomerDetails customer;
    Employee employee;
    Company company;
};

// Prompt 8
type Event record {
    string eventName;
    string eventDate;
    string location;
    string companyName;
    string keynoteSpeaker;
    string keynoteTopic;
    int numberOfAttendees;
    string[] industriesRepresented;
    string[] productsAnnounced;
    string[] executiveNames;
    string panelModeratorName;
    string panelModeratorAffiliation;
};

// Prompt 9
type InvalidExp Match;
