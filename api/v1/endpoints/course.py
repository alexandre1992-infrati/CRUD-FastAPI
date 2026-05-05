from typing import List 
from fastapi import APIRouter, status, Depends, HTTPException, Response
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from models.courses_model import CourseModel as Course
from schemas.course_schema import CoursesSchema as CourseSchema
from core.dependency import get_session


router = APIRouter()

#Rota - Método POST 
@router.post('/', status_code=status.HTTP_201_CREATED, response_model=CourseSchema)
async def post_course(course: CourseSchema, db: AsyncSession = Depends(get_session)):
    new_course = Course(titulo=course.titulo, aulas=course.aulas, horas=course.horas)
    db.add(new_course)
    await db.commit()
    return new_course


#Rota = Método GET (Todos os cursos)
@router.get('/', response_model=List[CourseSchema])
async def get_courses(db: AsyncSession = Depends(get_session)):
    async with db as session:
        query = select(Course)
        result = await session.execute(query)
        courses: List[Course] = result.scalars().all()
        return courses


#Rota - Método GET (Curso específico)
@router.get('/{course_id}', response_model=CourseSchema, status_code=status.HTTP_200_OK)
async def get_course(course_id: int, db: AsyncSession = Depends(get_session)):
    async with db as session:
        query = select(Course).where(Course.id == course_id)
        result = await session.execute(query)
        course: Course = result.scalars_one_or_none()
        if not course:
            raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail='Curso não encontrado')
        return course


#Rota - Método PUT
@router.put('/{course_id}', response_model=CourseSchema, status_code=status.HTTP_202_ACCEPTED)
async def put_course(course_id: int, course: CourseSchema, db: AsyncSession = Depends(get_session)):
    async with db as session:
        query = select(Course).where(Course.id == course_id)
        result = await session.execute(query)
        existing_course: Course = result.scalars_one_or_none()
        if not existing_course:
            raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail='Curso não encontrado')
        existing_course.titulo = course.titulo
        existing_course.aulas = course.aulas
        existing_course.horas = course.horas
        await session.commit()
        return existing_course


#Rota - Método DELETE
@router.delete('/{course_id}', status_code=status.HTTP_204_NO_CONTENT)
async def delete_course(course_id: int, db: AsyncSession = Depends(get_session)):
    async with db as session:
        query = select(Course).where(Course.id == course_id)
        result = await session.execute(query)
        existing_course: Course = result.scalars_one_or_none()
        if not existing_course:
            raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail='Curso não encontrado')
        await session.delete(existing_course)
        await session.commit()
        return Response(status_code=status.HTTP_204_NO_CONTENT)    
        