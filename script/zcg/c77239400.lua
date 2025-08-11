--No.93六芒星之神 巨龙神(ZCG)
function c77239400.initial_effect(c)
	--xyz summon
	Xyz.AddProcedure(c,nil,12,2)
	c:EnableReviveLimit()   

	--不能直接攻击
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
	e2:SetCondition(c77239400.con)  
	c:RegisterEffect(e2)

	--清前场
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetDescription(aux.Stringid(77239400,0))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c77239400.cost)
	e3:SetTarget(c77239400.target3)
	e3:SetOperation(c77239400.operation3)
	c:RegisterEffect(e3)
	
	--清后场
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetDescription(aux.Stringid(77239400,1))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCost(c77239400.cost)
	e4:SetTarget(c77239400.target4)
	e4:SetOperation(c77239400.operation4)
	c:RegisterEffect(e4)
	
	--不会成为效果对象
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetValue(1)
	c:RegisterEffect(e7)		

	--奥利哈刚无效
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_FIELD)
	e10:SetCode(EFFECT_DISABLE)
	e10:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e10:SetRange(LOCATION_MZONE)	
	e10:SetTarget(c77239400.target)
	c:RegisterEffect(e10)
	
	--奥利哈刚除外
	local e11=Effect.CreateEffect(c)
	e11:SetDescription(aux.Stringid(77239400,2))
	e11:SetCategory(CATEGORY_REMOVE)
	e11:SetType(EFFECT_TYPE_IGNITION)
	e11:SetRange(LOCATION_MZONE)		
	e11:SetTarget(c77239400.target2)
	e11:SetOperation(c77239400.activate2)
	c:RegisterEffect(e11)   
end
-----------------------------------------------------------------------------
function c77239400.con(e)
	return e:GetHandler():GetOverlayCount()~=0
end
-----------------------------------------------------------------------------
function c77239400.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c77239400.target3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler()) end
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c77239400.operation3(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())
	Duel.Destroy(sg,REASON_EFFECT)
end
-----------------------------------------------------------------------------
function c77239400.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c77239400.target4(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c77239400.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c) end
	local sg=Duel.GetMatchingGroup(c77239400.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c77239400.operation4(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c77239400.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	Duel.Destroy(sg,REASON_EFFECT)
end
-----------------------------------------------------------------------------
function c77239400.target(e,c)
	return c:IsSetCard(0xa50)
end
-----------------------------------------------------------------------------
function c77239400.filter1(c)
	return c:IsSetCard(0xa50) and c:IsFaceup()
end
function c77239400.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c77239400.filter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local sg=Duel.GetMatchingGroup(c77239400.filter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c77239400.activate2(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c77239400.filter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	local ct=Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
	if ct>0 then
		Duel.Damage(1-tp,ct*2000,REASON_EFFECT) 
	end
end
