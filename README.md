# Matrix Multiply Project

18-341: Fall Semester of 2017

## Objective and Overview

The purpose of this project is to learn to use the special hardware features
available in modern FPGAs. In the past, you've used the CLBs for combinational
and sequential circuitry (though the synthesis tools made it such that you just
worried about getting your `always_comb` and `always_ff` blocks working). In
this project, you'll use hardware
[multiply-accumulate](https://en.wikipedia.org/wiki/Multiply%E2%80%93accumulate_operation)
and dual-port
[Block RAMs](https://www.altera.com/en_US/pdfs/literature/ug/ug_ram_rom.pdf)
on the FPGA.

This is an **individual** project, to be done on your Altera DE0 board.

## Schedule and Scoring

Project value | 45 points
--- | ---
Project start | 6 Sep 2017
Project due | 18 Sep 2017 at 12:30pm
Drop dead date | 19 Sep 2017 at 12:30pm

If you have not uploaded anything by the dropdead date, we will assume you
are no longer in the course. Why? Because the syllabus says you must attempt
every project. Not uploading anything and not showing up to explain what
you’ve done is not attempting the project — see the syllabus for details.

## A Note about Collaboration

Project 2 is to be accomplished individually.  All work must be your own.

Hints from others can be of great help, both to the hinter and the hintee.
Thus, discussions and hints about the assignment are encouraged.  However, the
project must be coded and written up individually (you may not show, nor view,
any source code from other students).  We may use automated tools to detect
copying.

Use Piazza to ask questions or come visit us during office hours (or email for
an appointment at another time).  We want to see you succeed, but you have to
ask for help.

## Project Overview

The problem to solve is the matrix equation

> Y = A * B

where **A** is a 64x64 byte matrix, and **Y** and **B** are 64x1 column vectors
(of bytes).  All values in the matrixes are 8-bit, unsigned integers. We’ll give
you **A** and **B**, both of which are static. You will include **A** and **B**
in your design (and thus download onto the board at configuration time).  Your
system will perform the calculation. Rather than have a complicated UI to view
each element of the resulting matrix (**Y**), *your system will simply sum up
all the values in the **Y** matrix* and display the least-significant 16-bits of
the resulting sum.

To make this easier to grade, you are to show two different values in the hex
displays.  **SW0** will be used to determine what to show.  If the switch is 0,
the hex display shows the 16-bit result of the calculation (in hex).  If the
switch is 1, the hex display will show the number of clock ticks (16-bits, in
hex) needed to execute the computation.

## Timing Analysis

As you may recall from 18-240, digital signals require a finite amount of time
to propagate through logic, which, in FPGAs, consists of look-up tables (LUTs)
and routing fabric.  Specific timing details of your boards are available in the
manual, but for this project we're mostly interested in the critical path delay
-- essentially a gauge of whether your code will produce a deterministic design.
If the longest path between registers takes > 1/50MHZ (i.e. 20ns) then your
signals might not arrive in time; alternatively, if the longest path is too
fast, then you might be wasting cycles.  Fortunately, Quartus has a built-in
tool called TimeQuest that will calculate this for you.  In the Tasks pane,
navigate to **Compile Design ➙ TimeQuest Timing Analyzer ➙ Slow 1200mV 85C Model
➙ Fmax Summary** and you should see something like this:

![Fmax Summary Image](/images/FmaxSummary.png)

The Fmax column is what were interested in.  Keep this value over 50MHz by
breaking up large blobs of combinational logic with registers, and your design
is guaranteed to work "as you coded it."  Let it fall below 50MHz, and all bets
are off.

For this project, your system is required to meet the timing requirements of the
50MHz clock, as shown in that 1200mV, 85C model.

## Timing Constraints

How did Quartus know that your clock was named **CLOCK_50**?  Well, it has some
hints from the inference process (i.e. it sees your always\_ff blocks are
posedge a signal that you connected to **CLOCK_50**).

If you want to tell Quartus what your clock is, then do the following:

1. From the menu, **Assignments ➙ TimeQuest Timing Analyzer Wizard**.
2. In the resulting dialog box, give your clock a name (I chose **CLOCK_50**,
   for my sanity).  You then associate it with a port that Quartus finds
   automatically (here, **CLOCK_50**).
3. Set the period to 20 (nanoseconds).  You could specify risen and fallen time
   periods, if your clock wasn't 50% duty cycle (but **CLOCK_50** is, so leave
   these alone).  ![Defining a clock](/images/Timing_Wizard.png)
4. Then, hit **Next** to generate a constraints file.
5. When you re-run TimeQuest, it will have a listing for the clock you just
   created and constrained.  Basically, it will give the same information as
   before, but you will get fewer "unconstrained" warnings.

![Clock Constraints](/images/TimingQuest_Clocks.png)

## For Credit

You will be graded on getting the right answer to the calculation, on the number
of clock ticks it takes to do the calculation (smaller is better), if it meets
timing, and your coding style.

The number of clock ticks?  Yes, since the chip we have has lots of multiply
units and block RAMs, you can organize the hardware and the **A** and **B**
matrices (and copies of them) so that the calculations can run concurrently.
You can use all of the hardware you want but the question is how fast can you
make it run?  You should count all clock ticks from when reset is no longer
asserted and the calculation starts, until when the result of the calculation is
stored in a register.  After that, the clock tick counter doesn’t increment.

Getting the right answer?  Note that you can organize your data in different
ways to obtain fast implementations.  You can apply some algebraic manipulations
if you think it will be better. And remember, we’re only interested in the final
summation of the **Y** vector.

BTW, you must use the multiply and block RAM special features.  I'm not sure why
you wouldn't, but I've heard reports of student is previous semesters trying to
skip by without learning about the FPGA components.  So sad for them...

Note that we will give a lot of points for just getting it to run.  Getting it
to run faster is worth more, see the grading sheet.

## Model Organization

The header for your module should resemble the following:

```systemverilog
module ChipInterface
  (input  logic       CLOCK_50,
   input  logic [9:0] SW,
   input  logic [2:0] BUTTON,
   output logic [6:0] HEX3_D, HEX2_D, HEX1_D, HEX0_D);
```

**BUTTON0**, when depressed, will reset the system.

Develop your code in a file called **matrix_multiply.sv**.  There is really no
TA testbench for this project.  It just runs on the DE0 board and shows its
results.  To do the calculation again, hit reset (you should get the same
result).

The ROMs and multiplier that you will instantiate are detailed below.  The two
matrices (ROMs) are initialized via the *.mif files. We are providing two
different **A** and **B** matrices. The **A** matrix is provided in row-major
order.

* **matA_1.mif** and **matB_1.mif** will produce the result **16'hB6AB**.
* **matA_2.mif** and **matB_2.mif** will produce the result **16'h73B6**.

To use these, copy one set (e.g., both *_1.mif, or both *_2.mif) files to
**matA.mif** and **matB.mif** files and use the makefile as specified below. The
result given above is what you should expect to see if you’ve done the
calculations correctly.

We have also provided a python script **generate_matrix.py**, which you can
execute to generate a random problem if you like (it even prints out the
answer).  We will be grading you with a random problem generated from this
python program.

```sh
$ python generate_matrix.py matA_gen.mif matB_gen.mif
Matrix files created: matA_gem.mif matB_gen.mif
Accumulated product: 779d
```

To make use of the Block RAM and embedded multipliers, instantiate, connect and
use the according to the modules listed below.  If you deviate too much from
these, then the synthesis tool won't recognize that you want the component and
will do something else entirely.

Here are the headers of the component modules in a somewhat cleaned up format.
We have provided these in **romA.v**, **romB.v** and **multiplier.v** files.  I
wouldn't recommend modifying those files.

```systemverilog
module romA
 (input  logic [11:0] address_a, address_b,
  input  tri1         clock,  // I don't know why this is tri1
  output logic [7:0]  q_a, q_b);

// lots of generated code.  Don't touch!

endmodule : romA

module romB
 (input  logic [5:0] address_a, address_b,
  input  tri1        clock,  // Still no clue
  output logic [7:0] q_a, q_b);

// lots of generated code.  Don't touch!

endmodule : romB
```

**romA** contains 4096 one-byte wide elements, hence the 12 bits address lines.
**romB** contains 64 one-byte wide elements, hence 6 bits for address lines.

The ROMs are dual ported and thus you can provide two addresses and read two
elements simultaneously.  **address_a** address line provides the data read on
**q_a**. The same is true for **address_b** and **q_b**.

The ROMs have registered inputs, meaning that the ROM loads the address values
into its own internal registers at each clock edge.  The results read from the
ROM appear on **q_a** and **q_b** after that clock edge.  So, you present the
addresses in one state and read the results in the next.

The data in **romA** is defined by **romA.mif** and **romB** data is defined by
**romB.mif**.  By specifying values for the ROM data, the on-chip implementation
of the ROMs will be initialized to these values.  See the note above about the
two different sets of **A** and **B** we have provided.

Hardware usage on the chip: **romA** uses 4 x M9K Block RAMs, and **romB** uses
1 x M9K Block RAM.  The Cyclone III chip has a total of 56 such block RAMs.

The embedded multiplier has a module header that looks like:
```systemverilog
module multiplier
  (input  logic  [7:0] dataa, datab,
   output logic [15:0] result);

...

endmodule : multiplier
```

This is a byte multiplier that produces a 16-bit result.  Simply connect the two
operands into **dataa** and **datab**, and then patiently wait for the result to
show up on result output _combinationally_.

Hardware usage on the chip: the above uses 1 9x9 multiplier. The Cyclone chip
has 56 such multipliers.

## Simulating with VCS

If you want to debug your design, you're not going to have any fun sitting in
the lab synthesizing and downloading again and again.  The modules that tell
Quartus to use the special hardware units (like the roms and multiplier)
conveniently come with functional models that can be used in simulation.  We've
provided a makefile that will build all of the **.sv** files in your directory,
along with Altera's functional models, using VCS.

In your project directory along with your own SystemVerilog files, place the
following files:

* romA.v
* romB.v
* multiplier.v
* matA.mif
* matB.mif

Create a sub-directory in this project directory and place the given Makefile
inside.  Yep, that's right — the makefile is designed to run VCSon the files in
its parent directory.  Thus, all of the extra files that VCS likes to create
won't conflict with all of the extra files that Quartus likes to create.  Simply
run “make” in this newly created directory (the subdirectory!) to get ./simv.
You can ignore errors that are not from your SystemVerilog files.

To simulate, you need to put together a testbench that drives **CLOCK_50**, and
then run:
```sh
$ cd yourProjectDirectory/SubdirectoryWithMakefile
$ make
$ ./simv
```

VCS may print some “Too few instance port connections” warnings from a file
called **altera_lnsim.sv**. You can safely ignore these warnings.

## Synthesizing with Quartus

If starting a new project, create a directory for the project.  In this
directory, place:

* romA.v
* romB.v
* multiplier.v
* matA.mif
* matB.mif

Start a project in Quartus with the Project Wizard.  When prompted to add files
to the project, add **romA.v**, **romB.v** and **multiplier.v**.

If a project already exists (like if you want to swap *.mif files), then in the
Project Navigator window, switch to the **Files** tab. Right click on **Files**
and click **Add/Remove Files in Project**.

Include a **DE0_Default.qsf** file to connect your pins.

## Some Other Things you Should Learn

In the last project, I introduced you to the DE0 User Manual.  That manual isn't
as useful for this project, as we are trying to use components that aren't part
of the board, but are part of the FPGA itself.  Therefore, you should get to
know a different manual — the Cyclone III Device Handbook.  This manual is found
on [http://altera.com] or on the DVD in the box (though the DVD has an earlier
version, I haven't found any issues with it).  I have also posted a copy on
Canvas.  The manual describes, in great detail, everything that happens inside
the FPGA.  If you wanted to know how big the LUTs in the CLBs were, this is the
document (chapter 2).  If you wanted to know how the multipliers work ("hmm. I
wonder if the multiplier can work on signed values?") this is the document
(chapter 5, in table 5-3).  If you wanted to know how the memory blocks work
("hmm. I wonder if they support dual-port mode?") this is the document (chapter
4, page 4-8).

Please take a few minutes to skim through the Cyclone III Device Handbook.
Especially, look at Chapters 4 and 5, which cover the devices for this project.

You should be using **generate** statements to instantiate (almost) all those
BRAMs and multipliers.

## How To Turn In Your Solution

This semester we will be using
[Github Classroom](https://classroom.github.com/classrooms/31452665-18-341-fall17)
to hand-out as well as hand-in project code. Make sure to commit regularly and
provide informative messages, as this will help TAs immensely to provide
feedback.

When you have finished this project you should tag the release for submission
and push your repo to GitHub.

1. Tag the latest commit as "final"
    ```sh
    $ git tag -a final -m "Final submission for 18341 P2"
    ```

2. Check that the tag was created successfully
    ```sh
    $ git tag
    final
    ```

3. Push repo to GitHub.
    ```sh
    $ git push --tags
    ```

**If you need to alter your submission, remember to delete the tag**

Remotely:
```sh
$ git push --delete final
```

Locally:
```sh
$ git tag -d final
```

## Demos and Late Penalty

We will have demo times outside of class times on or near the due date.  Since
we will demo from the files in your repo, it is possible that you’ll demo on a
following day.

**Define Late:**  Lateness is determined by the file dates of your repo.

**Grace Day:**  You may use your grace day to turn in the solution up to 24
hours late.  If you do not intend to use a grace day (or have already used
yours), make sure you have something in the repo (and have pushed the repo) at
the deadline to avoid getting a zero on this project.
