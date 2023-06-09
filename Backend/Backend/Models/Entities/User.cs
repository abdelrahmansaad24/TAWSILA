﻿using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace Backend.Models.Entities;

public class User
{
    [Key]
    [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
    public int Id { get; set; }

    [Required]
    [Unicode]
    [MaxLength(255)]
    public string Email { get; set; } = null!;

    [Required]
    [Unicode(false)]
    [MaxLength(255)]
    public string Password { get; set; } = null!;

    [Required]
    [Unicode]
    [MaxLength(255)]
    public string FirstName { get; set; } = null!;

    [Required]
    [Unicode]
    [MaxLength(255)]
    public string LastName { get; set; } = null!;

    [Required]
    [Unicode(false)]
    [MaxLength(255)]
    public string PhoneNumber { get; set; } = null!;

    [Required]
    public string Avatar { get; set; } = "";

    [Required]
    public bool HasWhatsapp { get; set; }

    [Required]
    public bool IsEmailVerified { get; set; }

    [Required]
    public bool IsDeleted { get; set; }

    [Required]
    public DateTime CreatedAt { get; set; }

    [Required]
    public DateTime UpdatedAt { get; set; }

    [InverseProperty("Owner")]
    public virtual List<Car> Cars { get; set; } = null!;

    [InverseProperty("Reviewee")]
    public virtual List<Review> Reviews { get; set; } = null!;

    public object Clone()
    {
        return new User
        {
            Id = Id,
            Email = Email,
            Password = Password,
            FirstName = FirstName,
            LastName = LastName,
            PhoneNumber = PhoneNumber,
            Avatar = Avatar,
            HasWhatsapp = HasWhatsapp,
            IsEmailVerified = IsEmailVerified,
            IsDeleted = IsDeleted,
            CreatedAt = CreatedAt,
            UpdatedAt = UpdatedAt,
        };
    }
}
