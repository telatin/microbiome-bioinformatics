---
layout: post
title:  "A primer on Python data structures"
author: at
categories: [ python, data-structures ]
image: assets/images/python.png
hidden: false
---

# Data Structures in Python

## Introduction
Welcome to this quick introduction to data structures in Python.
We will introduce you to the concept of **data structures**, their importance, and the common data structures that are used in programming.

**So, what are data structures?** 
In simple terms, a data structure is a way of organizing and storing data in a computer so that it can be accessed and used efficiently. It can be thought of as a container for data, with different ways of organizing the data depending on the structure used.

Data structures are important in programming because they can *greatly affect the efficiency and speed of your code*. By using the right data structure for a specific task, you can optimize your code for faster processing times and more efficient memory usage.

There are many different data structures that can be used in programming, but some of the most common ones include:
* lists, 
* tuples, 
* sets, and 
* dictionaries. 

*Lists* are used to store a collection of items, while *tuples* are similar but are immutable, meaning they cannot be modified once created. *Sets* are used to store unique values, while *dictionaries* are used to store key-value pairs.

## Built-in data structures

### Lists
Lists are a collection of ordered items, enclosed in square brackets `[ ].` They can store multiple data types such as integers, floats, strings, etc. A list is usually homogeneous, but this is not a requirement and can store all the types that are needed.
Here is an example of a list:

```python
a_list = [1, 2, 3, "hello", 5.6]` 
```
You can access individual items in a list by using the index number in square brackets, starting from 0. Negative indexes can be used to extract elements starting from the end, where the last item has index -1.
For example:

```python
print(a_list[0]) # Output: 1
print(a_list[3]) # Output: hello
print(a_list[-1])# Output: 5.6
```

You can also modify items in a list by assigning a new value to the index. For example:

```python
a_list[3] = "world"
print(a_list) # Output: [1, 2, 3, "world", 5.6]
```    

### Tuples
Tuples are similar to lists, but they are immutable, meaning that once created, their values cannot be changed. They are enclosed in parentheses ( ). Here is an example of a tuple:
    
```python
my_tuple = (1, 2, 3, "hello", 5.6)
```
You can access individual items in a tuple using the same indexing method as lists:

```python
print(my_tuple[3]) # Output: "hello"
```

However, you cannot modify the values of a tuple once it's created.
    
### Sets
Sets are used to store unique values, and they are enclosed in curly braces { }. Here is an example of a set:
    
```python
my_set = {1, 2, 3, 3, 4, 4, 5}
```python

Note that the duplicate values are automatically removed, and only the unique values are stored in the set. You can add new values to a set using the `add()` method:

```python
my_set.add(6)
print(my_set) # Output: {1, 2, 3, 4, 5, 6}` 
```
    
### Dictionaries

Dictionaries are used to store key-value pairs, and they are enclosed in curly braces `{ }`. Here is an example of a dictionary:
    
```python
my_dict = {"name": "John", "age": 25, "city": "New York"}
```
You can access the value of a specific key in a dictionary by using the key name:

```python
print(my_dict["name"]) # Output: "John"
```
You can also modify the value of a key by assigning a new value to it:


```python
my_dict["age"] = 30
print(my_dict) # Output: {"name": "John", "age": 30, "city": "New York"}
```
 
Dictionaries are very useful so we can have a deeper look at them. Let's create a simple dictionary to help us understand how they work. We will create a dictionary to store the codon frequencies for the amino acid alanine.

```python
alanine_codons = {"GCT": 0.26, "GCC": 0.45, "GCA": 0.17, "GCG": 0.12}
```
Here, the keys are the codons for alanine, and the values are their respective frequencies. To access the value associated with a particular key, you can use the square bracket notation with the key as the index.
```python
print(alanine_codons["GCT"]) # Output: 0.26
```
You can also add new key-value pairs to the dictionary using the square bracket notation.
```python
alanine_codons["GCU"] = 0.10
print(alanine_codons) # Output: {"GCT": 0.26, "GCC": 0.45, "GCA": 0.17, "GCG": 0.12, "GCU": 0.10}
```
If you try to access a key that does not exist in the dictionary, it will raise a `KeyError`.
```python
print(alanine_codons["AAA"]) # Output: KeyError: 'AAA'
```
To avoid this, you can use the `get()` method instead. If the key is not found in the dictionary, `get()` will return `None` by default, but you can specify a default value to return instead, as a second argument of the function.

```python
print(alanine_codons.get("AAA")) # Output: None
print(alanine_codons.get("AAA", "N/A")) # Output: N/A`
```
You can also loop through the keys and values of a dictionary using a for loop and the `items()` method.
```python
for codon, freq in alanine_codons.items():
    print(f"The frequency of {codon} is {freq}.")
```
Output:
```text
The frequency of GCT is 0.26.
The frequency of GCC is 0.45.
The frequency of GCA is 0.17.
The frequency of GCG is 0.12.
The frequency of GCU is 0.10.
```

#### A working example

We accessed a dictionary that was initialized with a single assignment. In real life we often *populate* dictionaries reading data from a source.  
Here a complete example on how to populate the codon frequency code starting from a DNA string.

```python
# Define the DNA sequence
dna_sequence = "ATGACGCTGAGCTGTACGTCGACTACGTAGCATCGATCGTACGAGCTAGCTAGCTAGCTAGCTAGCTAGCTAGCTAGCTAGCTAGCTAGCTAGCTAGCTAGCTAGCT"
# Define the dictionary for codon frequencies
codon_freq = {}
```

Then we can use a loop to scan the sequence codon by codon:

```python
# Loop through the DNA sequence in 3 nucleotide increments (i.e. codons)
for i in range(0, len(dna_sequence), 3):
    # Extract the codon from the DNA sequence
    codon = dna_sequence[i:i+3]
    
    # If the codon is already in the dictionary, increment its count by 1
    if codon in codon_freq:
        codon_freq[codon] += 1
    # If the codon is not in the dictionary, add it with a count of 1
    else:
        codon_freq[codon] = 1

# Normalize the counts to frequencies
total_counts = sum(codon_freq.values())
# Using a dictionary comprehension (*see below), we can create a new dictionary
codon_freq = {codon: count/total_counts for codon, count in codon_freq.items()}

# Print the resulting codon frequencies
print(codon_freq)
```

Here, we first defined a random DNA sequence of 100 nucleotides. We then defined an empty dictionary to store the codon frequencies. We then looped through the DNA sequence in 3 nucleotide increments (i.e. codons) and extracted each codon. We checked whether the codon was already in the dictionary, and if so, we incremented its count by 1. If the codon was not in the dictionary, we added it with a count of 1. Once we had counted all the codons, we normalized the counts to frequencies by dividing each count by the total number of codons. Finally, we printed the resulting codon frequencies.

#### * More on dictionary comprehension

This line of code is using a dictionary comprehension to create a new dictionary called `codon_freq`. It is taking each item in the `codon_freq` dictionary (which was previously populated with the counts of each codon), and using it to create a new key-value pair in the `codon_freq` dictionary.

The syntax of the dictionary comprehension is as follows: `{key_expression: value_expression for item in iterable}`. In this case, the `key_expression` is `codon`, the `value_expression` is `count/total_counts`, and the `iterable` is `codon_freq.items()`.

The `iterable` is a list of tuples, where each tuple contains a key-value pair from the `codon_freq` dictionary. The `for` loop in the dictionary comprehension iterates over each of these tuples, assigning the key to the variable `codon` and the value to the variable `count`. The `key_expression` assigns `codon` as the key for the new dictionary, and the `value_expression` assigns the frequency of that codon (i.e. `count/total_counts`) as the value for the new dictionary.

So, in summary, this line of code is taking the counts of each codon in the `codon_freq` dictionary and using them to create a new dictionary called `codon_freq`, where each codon is associated with its frequency in the DNA sequence.

## Other structures

Python has several standard **libraries** that offer useful new data structures beyond the built-in ones. Some examples are:

1.  `collections`: This library provides several useful data structures such as `defaultdict`, `Counter`, `OrderedDict`, and `deque`.
    
2.  `heapq`: This library provides a heap data structure that can be used to efficiently maintain a collection of items that can be sorted and queried in constant time.
    
3.  `array`: This library provides an array data structure that is similar to a list, but is more memory efficient for storing homogeneous data types.
    
4.  `queue`: This library provides implementations of several queue data structures, including `Queue`, `LifoQueue`, and `PriorityQueue`.
    
5.  `bisect`: This library provides a binary search algorithm that can be used to efficiently search for items in a sorted list or array.
    
6.  `graphlib`: This library provides data structures for working with graphs, including `Graph` and `DiGraph`.
    

These libraries can be imported and used in your Python code as needed. They can provide additional functionality and efficiency for working with data beyond what is offered by the built-in data structures. We will cover them in another tutorial.


### defaultdict

A `defaultdict` is a dictionary-like object that provides a default value for a nonexistent key. This can be useful when you want to count the occurrences of items in a collection. Here's an example:
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
```python
from collections import deque

my_list = ['A', 'C', 'G', 'T', 'A', 'C', 'G', 'T', 'A', 'C', 'G', 'T']
my_deque = deque(my_list)

my_deque.append('N')In this example, we create a list of nucleotides and then create a `deque` called `my_deque`
my_deque.popleft()

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

```python
defaultdict(<class 'int'>, {'A': 16, 'T': 16, 'G': 22, 'C': 16})` 
```

Note that since we used `defaultdict(int)`, the default value for any missing key is `0`. This means that we don't need to explicitly initialize each key with a value of `0` before updating it. If we had used a regular `dict` instead, we would have needed to write something like `if nucleotide not in nucleotide_counts: nucleotide_counts[nucleotide] = 0` before incrementing the count.

Here's another example of using a **`deque`** to implement a sliding window over a DNA sequence:

```python
from collections import deque

def sliding_window(sequence, window_size):
    """Generate a sliding window over a DNA sequence."""
    sequence = deque(sequence[:window_size], maxlen=window_size)
    yield sequence

    for base in sequence:
        sequence.append(base)
        yield sequence

# Example usage
sequence = "ACGTAGCTAGCTAGCTAGCTAGCTAGCTAGCTAGCTAGCTAGCTAGCTAGCTAGCTAGCTAGCTAGCTAGCTAGCTAGCTAGCTAGCT"
window_size = 5

for window in sliding_window(sequence, window_size):
    print("".join(window))
```

In this example, we define a function called `sliding_window` that takes a DNA sequence and a window size as input. The function uses a `deque` to implement a sliding window over the sequence. We first create a `deque` containing the first `window_size` bases of the sequence. We then yield the initial `deque`, and for each subsequent base in the sequence, we append it to the `deque` and yield the resulting `deque`.

Finally, we demonstrate the use of the `sliding_window` function by applying it to a DNA sequence with a window size of 5. The function generates all possible windows of size 5 over the sequence and prints each one to the console.


## Conclusions
Data structures are a fundamental concept in programming that can greatly impact the efficiency and speed of your code. By using the appropriate data structure for a specific task, you can optimize your code and make it more efficient. In the next lessons, we will dive deeper into each of the common data structures and learn how to use them effectively in Python.


