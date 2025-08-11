--Number S39 - Utopia ONE
local s, id = GetID()
function s.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	Xyz.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsAttribute,ATTRIBUTE_LIGHT),4,3,s.ovfilter,aux.Stringid(86532744,1))

	--attack up
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_DAMAGE)
	e1:SetDescription(aux.Stringid(86532744,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1,false,EFFECT_MARKER_DETACH_XMAT)

	--cannot destroyed
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e0:SetValue(s.indes)
	c:RegisterEffect(e0)

	--self destroy
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DISABLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.descon)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_DISABLE_EFFECT)
	c:RegisterEffect(e3)
end
s.xyz_number=39
s.listed_names={84013237}

function s.mfilter(c,xyzc)
	return c:IsFaceup() and c:IsCode(84013237) and c:IsCanBeXyzMaterial(xyzc)
end
function s.spcon(e,c,og)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=nil
	if og then
		mg=og:Filter(s.mfilter,nil,c)
	else
		mg=Duel.GetMatchingGroup(s.mfilter,tp,LOCATION_MZONE,0,nil,c)
	end
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 and mg:GetCount()>0
		and Duel.GetLP(tp)<=Duel.GetLP(1-tp)-3000 
end
function s.spop(e,tp,eg,ep,ev,re,r,rp,c,og)
	local g=nil
	local sg=Group.CreateGroup()
	if og then
		g=og
		local tc=og:GetFirst()
		while tc do
			sg:Merge(tc:GetOverlayGroup())
			tc=og:GetNext()
		end
	else
		local mg=Duel.GetMatchingGroup(s.mfilter,tp,LOCATION_MZONE,0,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		g=mg:FilterSelect(tp,s.mfilter,1,1,nil)
			local tc1=g:GetFirst()
		sg:Merge(tc1:GetOverlayGroup())
	end
	Duel.Overlay(c,sg)
	c:SetMaterial(g)
	Duel.Overlay(c,g)
end

function s.indes(e,c)
	return not e:GetHandler():GetBattleTarget():IsSetCard(0x48) and not e:GetHandler():GetBattleTarget():IsSetCard(0x1048)
	  and not e:GetHandler():GetBattleTarget():IsSetCard(0x2048)
end

function s.desfilter2(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and (not c:IsSetCard(0x48) or c:IsSetCard(0x1048))
end
function s.descon2(e)
	local c=e:GetHandler()
	return Duel.IsExistingMatchingCard(s.desfilter2,c:GetControler(),0,LOCATION_MZONE,1,c)
end
 function s.ovfilter(c,tp,lc)
	return c:IsFaceup() and c:IsSummonCode(lc,SUMMON_TYPE_XYZ,tp,84013237)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=e:GetHandler():GetOverlayGroup():GetCount()
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) and Duel.GetLP(tp)>1 end
	e:GetHandler():RemoveOverlayCard(tp,g,g,REASON_COST)
	Duel.SetLP(tp,1)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_MZONE,1,nil) end
	local sg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_MZONE,nil)
	local sg2=Duel.GetMatchingGroup(s.ovfilter2,tp,0,LOCATION_MZONE,nil,e)
	  local dam=0
	  local tc=sg2:GetFirst()
	  while tc do
	  local atk=tc:GetAttack()
	  dam=dam+atk
	  tc=sg2:GetNext() end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,sg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
end
function s.ovfilter2(c,e)
	return c:IsAbleToRemove() and not c:IsImmuneToEffect(e)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
    local sg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_MZONE,nil)
    if Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)>0 then
        Duel.BreakEffect()
        local g=Duel.GetOperatedGroup()
        local dam=0
        local tc=g:GetFirst()
        while tc do
            local atk=tc:GetPreviousAttackOnField()
            dam=dam+atk
            tc=g:GetNext() 
        end
        Duel.Damage(1-tp,dam,REASON_EFFECT) 
    end
end
 function s.infilter(e,c)
	return c:IsSetCard(0x48) and c:IsType(TYPE_MONSTER)
end

function s.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetLP(c:GetControler())>1000
end