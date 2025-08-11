--Number 77: The Seven Sins
local s, id = GetID()
function s.initial_effect(c)
	--xyz summon
	Xyz.AddProcedure(c,nil,12,3)
	c:EnableReviveLimit()

	--cannot destroyed
	  local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	  e0:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e0:SetValue(s.indes)
	c:RegisterEffect(e0)

	--destroy
	local e1=Effect.CreateEffect(c)
	--e1:SetProperty(0)	   
	e1:SetDescription(aux.Stringid(3536537,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1,false,EFFECT_MARKER_DETACH_XMAT)

	--Negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(77498348,2))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.condition)	  
	e2:SetCost(s.cost)
	e2:SetOperation(s.operation2)
	c:RegisterEffect(e2,false,EFFECT_MARKER_DETACH_XMAT)
	local e5=e2:Clone()
 e5:SetDescription(aux.Stringid(77036039,0))
	e5:SetCondition(s.condition2)	  
	e5:SetOperation(s.operation3)
	c:RegisterEffect(e5,false,EFFECT_MARKER_DETACH_XMAT)
end
s.xyz_number=77
s.listed_series = {0x48}

function s.indes(e,c)
	return not e:GetHandler():GetBattleTarget():IsSetCard(0x48) 
	  and not e:GetHandler():GetBattleTarget():IsSetCard(0x1048) and not e:GetHandler():GetBattleTarget():IsSetCard(0x2048)
end

function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	if Duel.Destroy(g,REASON_EFFECT) then
		Duel.BreakEffect()
			local g2=Duel.GetOperatedGroup()
		Duel.Overlay(e:GetHandler(),g2)
	end
end

function s.filter1(c,e)
	return c==e:GetHandler()
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	--if re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and not re:IsHasType(EFFECT_TYPE_ACTIVATE) then return false end
	local ex,tg,tc,cp,cv=Duel.GetOperationInfo(ev,CATEGORY_REMOVE)
	return ex and tg~=nil and tc+tg:FilterCount(s.filter1,nil,e)-tg:GetCount()>0 
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_REMOVE)
	e1:SetValue(1)
	e1:SetReset(RESET_CHAIN)
	c:RegisterEffect(e1) 
end

function s.condition2(e,tp,eg,ep,ev,re,r,rp)
	--if re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and not re:IsHasType(EFFECT_TYPE_ACTIVATE) then return false end
	local ex,tg,tc,cp,cv=Duel.GetOperationInfo(ev,CATEGORY_DESTROY)
	return ex and tg~=nil and tc+tg:FilterCount(s.filter1,nil,e)-tg:GetCount()>0 
end
function s.operation3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetValue(1)
	e1:SetReset(RESET_CHAIN)
	c:RegisterEffect(e1) 
	  local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	c:RegisterEffect(e2)	
end
