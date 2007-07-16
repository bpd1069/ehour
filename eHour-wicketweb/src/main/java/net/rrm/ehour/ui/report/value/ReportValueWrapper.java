/**
 * Created on Mar 4, 2007
 * Created by Thies Edeling
 * Copyright (C) 2005, 2006 te-con, All Rights Reserved.
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
 * 
 * thies@te-con.nl
 * TE-CON
 * Legmeerstraat 4-2h, 1058ND, AMSTERDAM, The Netherlands
 *
 */

package net.rrm.ehour.ui.report.value;

import java.io.Serializable;


/**
 * Report value 
 **/

public class ReportValueWrapper implements Comparable<ReportValueWrapper>, Serializable
{
	private static final long serialVersionUID = 6316356835650959522L;
	protected	Integer	id;
	protected	String	name;
	
	/**
	 * 
	 * @param id
	 * @param name
	 */
	public ReportValueWrapper(Integer id, String name)
	{
		this.id = id;
		this.name = name;
	}
	
	/**
	 * Get identifier
	 * @return
	 */
	public Integer getId()
	{
		return id;
	}
	
	/**
	 * Get row name
	 * @return
	 */
	public String getName()
	{
		return name;
	}

	/**
	 * 
	 */
	public int compareTo(ReportValueWrapper o)
	{
		return getName().compareToIgnoreCase(o.getName());
	}	
}