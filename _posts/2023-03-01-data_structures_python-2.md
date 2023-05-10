---
layout: post
title:  "A primer on Python data structures (2)"
author: at
categories: [ python, data-structures ]
image: assets/images/python.png
hidden: true
---

More data structures in Python using standard libraries.

# Notable libraries

Python has several standard **libraries** that offer useful new data structures beyond the built-in ones. Some examples are:

1. **`collections`**: This library provides several useful data structures such as `defaultdict`, `Counter`, `OrderedDict`, and `deque`.
    
2. `heapq`: This library provides a heap data structure that can be used to efficiently maintain a collection of items that can be sorted and queried in constant time.
    
3. `array`: This library provides an array data structure that is similar to a list, but is more memory efficient for storing homogeneous data types.
    
4. `queue`: This library provides implementations of several queue data structures, including `Queue`, `LifoQueue`, and `PriorityQueue`.
    
5. `bisect`: This library provides a binary search algorithm that can be used to efficiently search for items in a sorted list or array.
    
6. `graphlib`: This library provides data structures for working with graphs, including `Graph` and `DiGraph`.

These libraries can be imported and used in your Python code as needed. 
They can provide additional functionality and efficiency for working with data beyond what is offered by the built-in data structures. 
In this post, we will cover some of the most useful data structures from the `collections` library.

## Collections 

### defaultdict

A `defaultdict` is a dictionary-like object that provides a default value for a nonexistent key. 
This can be useful when you want to count the occurrences of items in a collection (without the need of checking if the key was already inserted).
Here's an example:

```python
from collections import defaultdict

my_list = ['A', 'C', 'G', 'T', 'A', 'C', 'G', 'T', 'A', 'C', 'G', 'T']
my_dict = defaultdict(int)

for base in my_list:
    my_dict[base] += 1

print(my_dict)
```

In this example, we create a list of nucleotides and then create a `defaultdict` called `my_dict` with a default value of 0. We then iterate over the list of nucleotides, adding 1 to the count for each nucleotide in the `my_dict` dictionary. Finally, we print the resulting dictionary, which shows the count of each nucleotide in the original list.

### Counter

A `Counter` is another useful data structure for counting the occurrences of items in a collection. It is similar to a `defaultdict`, but it provides several additional methods for working with the counts. Here's an example:

```python
from collections import Counter

my_list = ['A', 'C', 'G', 'T', 'A', 'C', 'G', 'T', 'A', 'C', 'G', 'T']
my_counter = Counter(my_list)

print(my_counter)
print(my_counter.most_common(2))
```

In this example, we create a list of nucleotides and then create a `Counter` called `my_counter`. We then print the resulting `my_counter` object, which shows the count of each nucleotide in the original list. We also use the `most_common` method to print the two most common nucleotides and their counts.

### OrderedDict

An `OrderedDict` is a dictionary-like object that remembers the order in which items were inserted. This can be useful when you want to preserve the order of elements in a list or other collection. Here's an example:

```python
from collections import OrderedDict

my_dict = OrderedDict()
my_dict['A'] = 1
my_dict['C'] = 2
my_dict['G'] = 3
my_dict['T'] = 4

print(my_dict.keys())
```

In this example, we create an `OrderedDict` called `my_dict` and add four key-value pairs to it. We then print the keys of the dictionary, which will be printed in the order in which they were inserted.

### deque

A `deque` is a double-ended queue data structure that allows you to efficiently append and pop items from both ends. This can be useful when you want to maintain a collection of items in which items are frequently added or removed from the beginning or end of the collection. Here's an example:

```python
from collections import deque

# Initialize a list with some elements
my_list = ['A', 'C', 'G', 'T', 'A', 'C', 'G', 'T', 'A', 'C', 'G', 'T']

# Convert the list into a deque
my_deque = deque(my_list)

# Now the list is a deque, with access to new methods
# Use the append method to add an element ('N') to the right end of the deque
my_deque.append('N') 

# Use the popleft method to remove an element from the left end of the deque
my_deque.popleft() 

# Print the final state of the deque
print(my_deque)
```

In this example, we create a list of nucleotides and then create a `deque` called `my_deque`

### Examples

In bioinformatics, we often need to count the occurrence of nucleotides or amino acids in a sequence. 
Here's an example of using **`defaultdict`** to count the frequency of nucleotides in a DNA sequence:

```python
from collections import defaultdict

sequence = "ATGCTGATCGTAGCTAGCTGACTGACTGACTGACGTAGCTGATCGTAGCTAGCTGACTGACTGACTGACGTAGCTGATCGTAGCTAGCTGACTGACTGACTGACG"

nucleotide_counts = defaultdict(int)
for nucleotide in sequence:
    nucleotide_counts[nucleotide] += 1

print(nucleotide_counts)
```

In this example, we first import the `defaultdict` class from the `collections` module. We then define a DNA sequence as a string. We create a `defaultdict` called `nucleotide_counts` with the default value of zero. We iterate over each nucleotide in the sequence and use the `nucleotide_counts` dictionary to keep track of the number of occurrences of each nucleotide.

Finally, we print the `nucleotide_counts` dictionary, which contains the count of each nucleotide in the sequence:

```text
defaultdict(<class 'int'>, {'A': 16, 'T': 16, 'G': 22, 'C': 16})` 
```

Note that since we used `defaultdict(int)`, the default value for any missing key is `0`. This means that we don't need to explicitly initialize each key with a value of `0` before updating it. If we had used a regular `dict` instead, we would have needed to write something like `if nucleotide not in nucleotide_counts: nucleotide_counts[nucleotide] = 0` before incrementing the count.

Here's another example of using a **`deque`** to implement a sliding window over a DNA sequence:

```python
from collections import deque

def sliding_window(sequence, window_size):
    """Generate a sliding window over a DNA sequence."""
    sequence_window = deque(sequence[:window_size], maxlen=window_size)
    yield  sequence_window

    for base in sequence[window_size:]:
        sequence_window.append(base)
        yield  sequence_window

# Example usage
sequence = "ACGTAGCTAGCTAGCTAGCTAGCTAGCTAGCTAGCTAGCTAGCTAGCTAGCTAGCTAGCTAGCTAGCTAGCTAGCTAGCTAGCTAGCT"
window_size = 5

for window in sliding_window(sequence, window_size):
    # each window will be a `deque` with window_size bases
    print("".join(window))
```

In this example, we define a function called `sliding_window` that takes a DNA sequence and a window size as input. The function uses a `deque` to implement a sliding window over the sequence. We first create a `deque` containing the first `window_size` bases of the sequence. We then yield the initial `deque`, and for each subsequent base in the sequence, we append it to the `deque` and yield the resulting `deque`.

Finally, we demonstrate the use of the `sliding_window` function by applying it to a DNA sequence with a window size of 5. The function generates all possible windows of size 5 over the sequence and prints each one to the console.


---

See also:

* [Part 1]({{ site.baseurl }}{% link _posts/2023-03-01-data_structures_python-1.md %})
