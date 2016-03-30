// Passive data node for hash tables.
struct Node {
    string word;
    Node* next;
};

class HashTable {
  public :
    HashTable ();
    HashTable (int K);
    virtual ~HashTable();
    void insert (string word);
    void remove (string word);      // You implement this!
    bool lookup (string word) const;
    void print () const;
    void report () const;
    static const int DefaultSize;
  protected :
    int getTableSize() const;
  private :
    vector<Node*> table;
  // The "hash" function will be defined by each child class,
  // each one using a different strategy.  But it needs to be
  // abstract (aka "pure virtual") in the abstract parent class.
  virtual int hash (string key) const = 0;
};

// Note that insert/lookup are completely defined here (and call hash) even
// tho hash is not defined here.  This is called the Template Method design
// pattern.  The hash function is private, meaning the children can't call
// it.  However, they can *define* it.  In fact, that's the only difference
// between the children classes: they each provide a difference
// implementation of hash!

const int HashTable::DefaultSize = 1000;
HashTable::HashTable() : table(DefaultSize) {}
HashTable::HashTable(int K) : table(K) {}

// The destructor has lots of garbage to clean up!  For each bucket with an
// overflow list, we delete the nodes.
HashTable::~HashTable(){
  for (int i=0; i<getTableSize(); i++) {
    Node* p = table[i];
    while (p!=NULL) {
      Node* temp = p;
      p = p->next;
      delete temp;
    }
  }
}
